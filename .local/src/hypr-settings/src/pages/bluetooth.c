#include "bluetooth.h"
#include "../utils/command.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    AdwSwitchRow *power_row;
    AdwSwitchRow *disc_row;
    AdwPreferencesGroup *paired_group;
    AdwPreferencesGroup *nearby_group;
    GtkButton *scan_btn;
    gboolean scanning;
    GList *paired_rows;
    GList *nearby_rows;
    GHashTable *paired_macs;
} BtWidgets;

static const char *get_device_icon(const char *name) {
    if (!name) return "bluetooth-active-symbolic";
    gchar *lower = g_utf8_casefold(name, -1);
    const char *icon = "bluetooth-active-symbolic";
    if (strstr(lower, "controller") || strstr(lower, "gamepad") || strstr(lower, "xbox") ||
        strstr(lower, "wireless controller") || strstr(lower, "dualsense") || strstr(lower, "switch")) {
        icon = "input-gaming-symbolic";
    } else if (strstr(lower, "headphone") || strstr(lower, "earbuds") || strstr(lower, "airpod") ||
               strstr(lower, "buds") || strstr(lower, "headset") || strstr(lower, "speaker")) {
        icon = "audio-headphones-symbolic";
    } else if (strstr(lower, "mouse") || strstr(lower, "trackball")) {
        icon = "input-mouse-symbolic";
    } else if (strstr(lower, "keyboard")) {
        icon = "input-keyboard-symbolic";
    }
    g_free(lower);
    return icon;
}

static void on_power_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec;
    BtWidgets *bw = (BtWidgets *)user_data;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("bluetoothctl power %s", active ? "on" : "off");
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);

    if (active) {
        gtk_widget_set_sensitive(GTK_WIDGET(bw->scan_btn), TRUE);
    } else {
        gtk_widget_set_sensitive(GTK_WIDGET(bw->scan_btn), FALSE);
    }
}

static void on_disc_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("bluetoothctl discoverable %s", active ? "on" : "off");
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void refresh_all_devices(BtWidgets *bw);

static void on_device_connect_clicked(GtkButton *btn, gpointer user_data) {
    char *mac = (char *)user_data;
    const char *label = gtk_button_get_label(btn);
    gboolean is_conn = (g_strcmp0(label, "Disconnect") == 0);
    char *cmd = g_strdup_printf("bluetoothctl %s %s", is_conn ? "disconnect" : "connect", mac);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
    gtk_button_set_label(btn, is_conn ? "Connect" : "Disconnect");
}

static gboolean on_refresh_timeout(gpointer user_data) {
    refresh_all_devices((BtWidgets *)user_data);
    return G_SOURCE_REMOVE;
}

static void on_device_remove_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn;
    BtWidgets *bw = (BtWidgets *)g_object_get_data(G_OBJECT(btn), "bw_ptr");
    char *mac = (char *)user_data;
    char *cmd = g_strdup_printf("bluetoothctl remove %s", mac);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);

    if (bw) {
        g_timeout_add(800, on_refresh_timeout, bw);
    }
}

static void on_pair_connect_clicked(GtkButton *btn, gpointer user_data) {
    BtWidgets *bw = (BtWidgets *)g_object_get_data(G_OBJECT(btn), "bw_ptr");
    char *mac = (char *)user_data;
    gtk_button_set_label(btn, "Pairing...");
    gtk_widget_set_sensitive(GTK_WIDGET(btn), FALSE);

    char *cmd = g_strdup_printf("bluetoothctl pair %s && bluetoothctl trust %s && bluetoothctl connect %s && notify-send -a 'Bluetooth' 'Device Connected' 'Successfully paired with %s'", mac, mac, mac, mac);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);

    if (bw) {
        g_timeout_add(2500, on_refresh_timeout, bw);
    }
}

static void on_nearby_loaded(gboolean success, const char *output, gpointer user_data) {
    BtWidgets *bw = (BtWidgets *)user_data;
    if (!success || !output) return;

    for (GList *l = bw->nearby_rows; l != NULL; l = l->next) {
        adw_preferences_group_remove(bw->nearby_group, GTK_WIDGET(l->data));
    }
    g_list_free(bw->nearby_rows);
    bw->nearby_rows = NULL;

    char **lines = g_strsplit(output, "\n", -1);
    int count = 0;

    for (int i = 0; lines[i] != NULL; i++) {
        if (g_str_has_prefix(lines[i], "Device ")) {
            char **parts = g_strsplit(lines[i], " ", 3);
            if (parts[0] && parts[1]) {
                const char *mac = parts[1];
                const char *name = parts[2] ? parts[2] : mac;

                // Skip if already in paired list
                if (bw->paired_macs && g_hash_table_contains(bw->paired_macs, mac)) {
                    g_strfreev(parts);
                    continue;
                }

                AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
                adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), name);
                adw_action_row_set_subtitle(row, mac);

                GtkWidget *icon = gtk_image_new_from_icon_name(get_device_icon(name));
                gtk_image_set_pixel_size(GTK_IMAGE(icon), 18);
                adw_action_row_add_prefix(row, icon);

                GtkWidget *pair_btn = gtk_button_new_with_label("Pair & Connect");
                gtk_widget_add_css_class(pair_btn, "suggested-action");
                gtk_widget_set_valign(pair_btn, GTK_ALIGN_CENTER);
                g_object_set_data(G_OBJECT(pair_btn), "bw_ptr", bw);
                g_signal_connect_data(pair_btn, "clicked", G_CALLBACK(on_pair_connect_clicked),
                                      g_strdup(mac), (GClosureNotify)g_free, 0);
                adw_action_row_add_suffix(row, pair_btn);

                adw_preferences_group_add(bw->nearby_group, GTK_WIDGET(row));
                bw->nearby_rows = g_list_append(bw->nearby_rows, row);
                count++;
            }
            g_strfreev(parts);
        }
    }
    g_strfreev(lines);

    if (count == 0) {
        AdwActionRow *empty = ADW_ACTION_ROW(adw_action_row_new());
        adw_preferences_row_set_title(ADW_PREFERENCES_ROW(empty), "No nearby devices found");
        adw_action_row_set_subtitle(empty, "Put your controller or headset in pairing mode and click 'Scan for Devices'");
        adw_preferences_group_add(bw->nearby_group, GTK_WIDGET(empty));
        bw->nearby_rows = g_list_append(bw->nearby_rows, empty);
    }
}

static void on_paired_loaded(gboolean success, const char *output, gpointer user_data) {
    BtWidgets *bw = (BtWidgets *)user_data;
    if (!success) return;

    for (GList *l = bw->paired_rows; l != NULL; l = l->next) {
        adw_preferences_group_remove(bw->paired_group, GTK_WIDGET(l->data));
    }
    g_list_free(bw->paired_rows);
    bw->paired_rows = NULL;

    if (bw->paired_macs) {
        g_hash_table_destroy(bw->paired_macs);
    }
    bw->paired_macs = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);

    int count = 0;
    if (output && *output) {
        char **lines = g_strsplit(output, "\n", -1);
        for (int i = 0; lines[i] != NULL; i++) {
            if (g_str_has_prefix(lines[i], "Device ")) {
                char **parts = g_strsplit(lines[i], " ", 3);
                if (parts[0] && parts[1]) {
                    char *mac = g_strdup(parts[1]);
                    char *name = g_strdup(parts[2] ? parts[2] : mac);

                    g_hash_table_add(bw->paired_macs, g_strdup(mac));

                    AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
                    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), name);

                    // Check connected status
                    char *info_cmd = g_strdup_printf("bluetoothctl info %s", mac);
                    char *info_out = run_cmd(info_cmd);
                    g_free(info_cmd);

                    gboolean connected = (info_out && strstr(info_out, "Connected: yes"));
                    if (connected) {
                        char *sub = g_strdup_printf("%s • Connected", mac);
                        adw_action_row_set_subtitle(row, sub);
                        g_free(sub);
                    } else {
                        adw_action_row_set_subtitle(row, mac);
                    }
                    g_free(info_out);

                    GtkWidget *icon = gtk_image_new_from_icon_name(get_device_icon(name));
                    gtk_image_set_pixel_size(GTK_IMAGE(icon), 18);
                    adw_action_row_add_prefix(row, icon);

                    GtkWidget *conn_btn = gtk_button_new_with_label(connected ? "Disconnect" : "Connect");
                    gtk_widget_set_valign(conn_btn, GTK_ALIGN_CENTER);
                    g_signal_connect_data(conn_btn, "clicked", G_CALLBACK(on_device_connect_clicked),
                                          g_strdup(mac), (GClosureNotify)g_free, 0);
                    adw_action_row_add_suffix(row, conn_btn);

                    GtkWidget *del_btn = gtk_button_new_from_icon_name("user-trash-symbolic");
                    gtk_widget_add_css_class(del_btn, "destructive-action");
                    gtk_widget_set_valign(del_btn, GTK_ALIGN_CENTER);
                    g_object_set_data(G_OBJECT(del_btn), "bw_ptr", bw);
                    g_signal_connect_data(del_btn, "clicked", G_CALLBACK(on_device_remove_clicked),
                                          g_strdup(mac), (GClosureNotify)g_free, 0);
                    adw_action_row_add_suffix(row, del_btn);

                    adw_preferences_group_add(bw->paired_group, GTK_WIDGET(row));
                    bw->paired_rows = g_list_append(bw->paired_rows, row);
                    count++;

                    g_free(name);
                    g_free(mac);
                }
                g_strfreev(parts);
            }
        }
        g_strfreev(lines);
    }

    if (count == 0) {
        AdwActionRow *empty = ADW_ACTION_ROW(adw_action_row_new());
        adw_preferences_row_set_title(ADW_PREFERENCES_ROW(empty), "No paired accessories found");
        adw_action_row_set_subtitle(empty, "Pair a new device from the list of available devices below");
        adw_preferences_group_add(bw->paired_group, GTK_WIDGET(empty));
        bw->paired_rows = g_list_append(bw->paired_rows, empty);
    }

    // Now fetch available devices
    run_cmd_async("bluetoothctl devices", on_nearby_loaded, bw);
}

static void refresh_all_devices(BtWidgets *bw) {
    run_cmd_async("bluetoothctl devices Paired", on_paired_loaded, bw);
}

static void on_scan_done(gboolean success, const char *output, gpointer user_data) {
    (void)success; (void)output;
    BtWidgets *bw = (BtWidgets *)user_data;
    bw->scanning = FALSE;
    gtk_button_set_label(bw->scan_btn, "Scan for Devices");
    gtk_widget_set_sensitive(GTK_WIDGET(bw->scan_btn), TRUE);
    refresh_all_devices(bw);
}

static void on_scan_clicked(GtkButton *btn, gpointer user_data) {
    BtWidgets *bw = (BtWidgets *)user_data;
    if (bw->scanning) return;

    bw->scanning = TRUE;
    gtk_button_set_label(btn, "Scanning nearby...");
    gtk_widget_set_sensitive(GTK_WIDGET(btn), FALSE);

    // Run active scan for 5 seconds, then refresh devices
    run_cmd_async("bluetoothctl --timeout 5 scan on", on_scan_done, bw);
}

GtkWidget *create_bluetooth_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Bluetooth");
    adw_preferences_page_set_icon_name(page, "bluetooth-active-symbolic");

    BtWidgets *bw = g_new0(BtWidgets, 1);

    // Controller group
    AdwPreferencesGroup *ctrl_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(ctrl_group, "Bluetooth Controller");
    adw_preferences_group_set_description(ctrl_group, "Radio power and pairing configuration");
    adw_preferences_page_add(page, ctrl_group);

    bw->power_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(bw->power_row), "Enable Bluetooth");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(bw->power_row), "Turn wireless radio on or off");

    GtkWidget *p_icon = gtk_image_new_from_icon_name("bluetooth-active-symbolic");
    gtk_image_set_pixel_size(GTK_IMAGE(p_icon), 18);
    adw_action_row_add_prefix(ADW_ACTION_ROW(bw->power_row), p_icon);

    char *show_out = run_cmd("bluetoothctl show");
    gboolean is_powered = FALSE;
    if (show_out) {
        if (strstr(show_out, "Powered: yes")) {
            is_powered = TRUE;
            adw_switch_row_set_active(bw->power_row, TRUE);
        }
        g_free(show_out);
    }
    g_signal_connect(bw->power_row, "notify::active", G_CALLBACK(on_power_toggled), bw);
    adw_preferences_group_add(ctrl_group, GTK_WIDGET(bw->power_row));

    bw->disc_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(bw->disc_row), "Make Discoverable");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(bw->disc_row), "Allow nearby accessories to discover this computer");
    g_signal_connect(bw->disc_row, "notify::active", G_CALLBACK(on_disc_toggled), bw);
    adw_preferences_group_add(ctrl_group, GTK_WIDGET(bw->disc_row));

    // Paired group
    bw->paired_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(bw->paired_group, "Paired Accessories");
    adw_preferences_group_set_description(bw->paired_group, "Currently bonded devices and controllers");
    adw_preferences_page_add(page, bw->paired_group);

    // Nearby group
    bw->nearby_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(bw->nearby_group, "Available Devices");
    adw_preferences_group_set_description(bw->nearby_group, "Discovered wireless accessories within range");

    bw->scan_btn = GTK_BUTTON(gtk_button_new_with_label("Scan for Devices"));
    gtk_widget_add_css_class(GTK_WIDGET(bw->scan_btn), "kde-btn-primary");
    gtk_widget_set_sensitive(GTK_WIDGET(bw->scan_btn), is_powered);
    g_signal_connect(bw->scan_btn, "clicked", G_CALLBACK(on_scan_clicked), bw);
    adw_preferences_group_set_header_suffix(bw->nearby_group, GTK_WIDGET(bw->scan_btn));
    adw_preferences_page_add(page, bw->nearby_group);

    // Automatically trigger initial population & discovery
    refresh_all_devices(bw);
    if (is_powered) {
        on_scan_clicked(bw->scan_btn, bw);
    }

    return GTK_WIDGET(page);
}
