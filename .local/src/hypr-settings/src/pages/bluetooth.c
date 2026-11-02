#include "bluetooth.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>

typedef struct {
    AdwSwitchRow *power_row;
    AdwSwitchRow *disc_row;
    AdwPreferencesGroup *paired_group;
    AdwPreferencesGroup *nearby_group;
    GtkButton *scan_btn;
    gboolean scanning;
    GList *device_rows;
} BtWidgets;

static void on_power_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("bluetoothctl power %s", active ? "on" : "off");
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_disc_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("bluetoothctl discoverable %s", active ? "on" : "off");
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_device_connect_clicked(GtkButton *btn, gpointer user_data) {
    char *mac = (char *)user_data;
    const char *label = gtk_button_get_label(btn);
    gboolean is_conn = (g_strcmp0(label, "Disconnect") == 0);
    char *cmd = g_strdup_printf("bluetoothctl %s %s", is_conn ? "disconnect" : "connect", mac);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
    gtk_button_set_label(btn, is_conn ? "Connect" : "Disconnect");
}

static void on_device_remove_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn;
    char *mac = (char *)user_data;
    char *cmd = g_strdup_printf("bluetoothctl remove %s", mac);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_devices_loaded(gboolean success, const char *output, gpointer user_data) {
    BtWidgets *bw = (BtWidgets *)user_data;
    if (!success || !output) return;

    // Clear old rows
    for (GList *l = bw->device_rows; l != NULL; l = l->next) {
        adw_preferences_group_remove(bw->paired_group, GTK_WIDGET(l->data));
    }
    g_list_free(bw->device_rows);
    bw->device_rows = NULL;

    char **lines = g_strsplit(output, "\n", -1);
    for (int i = 0; lines[i] != NULL; i++) {
        if (g_str_has_prefix(lines[i], "Device ")) {
            char **parts = g_strsplit(lines[i], " ", 3);
            if (parts[0] && parts[1] && parts[2]) {
                char *mac = g_strdup(parts[1]);
                char *name = g_strdup(parts[2]);

                AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
                adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), name);
                adw_action_row_set_subtitle(row, mac);
                adw_action_row_set_icon_name(row, "bluetooth-active-symbolic");

                // Check connected state
                char *info_cmd = g_strdup_printf("bluetoothctl info %s", mac);
                char *info_out = run_cmd(info_cmd);
                g_free(info_cmd);

                gboolean connected = (info_out && strstr(info_out, "Connected: yes"));
                if (connected) {
                    char *sub = g_strdup_printf("%s • Connected", mac);
                    adw_action_row_set_subtitle(row, sub);
                    g_free(sub);
                }
                g_free(info_out);

                GtkWidget *conn_btn = gtk_button_new_with_label(connected ? "Disconnect" : "Connect");
                gtk_widget_add_css_class(conn_btn, "flat");
                g_signal_connect_data(conn_btn, "clicked", G_CALLBACK(on_device_connect_clicked),
                                      g_strdup(mac), (GClosureNotify)g_free, 0);
                adw_action_row_add_suffix(row, conn_btn);

                GtkWidget *del_btn = gtk_button_new_from_icon_name("user-trash-symbolic");
                gtk_widget_add_css_class(del_btn, "flat");
                gtk_widget_add_css_class(del_btn, "destructive-action");
                g_signal_connect_data(del_btn, "clicked", G_CALLBACK(on_device_remove_clicked),
                                      g_strdup(mac), (GClosureNotify)g_free, 0);
                adw_action_row_add_suffix(row, del_btn);

                adw_preferences_group_add(bw->paired_group, GTK_WIDGET(row));
                bw->device_rows = g_list_append(bw->device_rows, row);

                g_free(name);
                g_free(mac);
            }
            g_strfreev(parts);
        }
    }
    g_strfreev(lines);
}

static void refresh_devices(BtWidgets *bw) {
    run_cmd_async("bluetoothctl devices", on_devices_loaded, bw);
}

static void on_scan_clicked(GtkButton *btn, gpointer user_data) {
    BtWidgets *bw = (BtWidgets *)user_data;
    if (!bw->scanning) {
        bw->scanning = TRUE;
        gtk_button_set_label(btn, "Scanning...");
        run_cmd_fire_and_forget("bluetoothctl --timeout 15 scan on");
    } else {
        bw->scanning = FALSE;
        gtk_button_set_label(btn, "Scan for Devices");
        run_cmd_fire_and_forget("bluetoothctl scan off");
    }
    refresh_devices(bw);
}

AdwPreferencesPage *create_bluetooth_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Bluetooth");
    adw_preferences_page_set_icon_name(page, "bluetooth-active-symbolic");
    adw_preferences_page_set_name(page, "bluetooth");

    BtWidgets *bw = g_new0(BtWidgets, 1);

    // Controller group
    AdwPreferencesGroup *ctrl_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(ctrl_group, "Bluetooth Controller");
    adw_preferences_group_set_description(ctrl_group, "Radio power and device visibility");
    adw_preferences_page_add(page, ctrl_group);

    bw->power_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(bw->power_row), "Enable Bluetooth");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(bw->power_row), "Turn wireless radio on or off");
    adw_action_row_set_icon_name(ADW_ACTION_ROW(bw->power_row), "bluetooth-active-symbolic");

    char *show_out = run_cmd("bluetoothctl show");
    if (show_out) {
        if (strstr(show_out, "Powered: yes")) {
            adw_switch_row_set_active(bw->power_row, TRUE);
        }
        g_free(show_out);
    }
    g_signal_connect(bw->power_row, "notify::active", G_CALLBACK(on_power_toggled), bw);
    adw_preferences_group_add(ctrl_group, GTK_WIDGET(bw->power_row));

    bw->disc_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(bw->disc_row), "Make Discoverable");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(bw->disc_row), "Allow nearby devices to pair with this PC");
    g_signal_connect(bw->disc_row, "notify::active", G_CALLBACK(on_disc_toggled), bw);
    adw_preferences_group_add(ctrl_group, GTK_WIDGET(bw->disc_row));

    // Paired group
    bw->paired_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(bw->paired_group, "Paired Accessories");
    adw_preferences_group_set_description(bw->paired_group, "Headphones, controllers, keyboards, and mice");
    adw_preferences_page_add(page, bw->paired_group);

    // Scan group
    AdwPreferencesGroup *scan_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(scan_group, "Nearby Discovery");
    bw->scan_btn = GTK_BUTTON(gtk_button_new_with_label("Scan for Devices"));
    gtk_widget_add_css_class(GTK_WIDGET(bw->scan_btn), "suggested-action");
    g_signal_connect(bw->scan_btn, "clicked", G_CALLBACK(on_scan_clicked), bw);
    adw_preferences_group_set_header_suffix(scan_group, GTK_WIDGET(bw->scan_btn));
    adw_preferences_page_add(page, scan_group);

    refresh_devices(bw);

    return page;
}
