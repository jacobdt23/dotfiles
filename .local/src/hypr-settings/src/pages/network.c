#include "network.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>

typedef struct {
    AdwSwitchRow *wifi_switch;
    AdwActionRow *active_row;
    AdwPreferencesGroup *networks_group;
    GList *network_rows;
} NetWidgets;

static void on_wifi_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("nmcli radio wifi %s", active ? "on" : "off");
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_connect_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn;
    char *ssid = (char *)user_data;
    char *cmd = g_strdup_printf("nmcli device wifi connect \"%s\"", ssid);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_networks_loaded(gboolean success, const char *output, gpointer user_data) {
    NetWidgets *nw = (NetWidgets *)user_data;
    if (!success || !output) return;

    for (GList *l = nw->network_rows; l != NULL; l = l->next) {
        adw_preferences_group_remove(nw->networks_group, GTK_WIDGET(l->data));
    }
    g_list_free(nw->network_rows);
    nw->network_rows = NULL;

    GHashTable *seen = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    char **lines = g_strsplit(output, "\n", -1);

    for (int i = 0; lines[i] != NULL; i++) {
        char **parts = g_strsplit(lines[i], ":", 4);
        if (parts[0] && parts[1] && parts[2]) {
            gboolean in_use = (g_strcmp0(parts[0], "*") == 0);
            char *ssid = g_strdup(g_strstrip(parts[1]));
            char *bars = parts[2];
            char *sec = parts[3] ? parts[3] : "Open";

            if (strlen(ssid) > 0 && !g_hash_table_contains(seen, ssid)) {
                g_hash_table_add(seen, g_strdup(ssid));

                AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
                adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), ssid);
                char *sub = g_strdup_printf("Signal: %s • %s", bars, sec);
                adw_action_row_set_subtitle(row, sub);
                g_free(sub);
                adw_action_row_set_icon_name(row, "network-wireless-symbolic");

                if (in_use) {
                    GtkWidget *badge = gtk_label_new("Connected");
                    gtk_widget_add_css_class(badge, "accent");
                    adw_action_row_add_suffix(row, badge);
                } else {
                    GtkWidget *btn = gtk_button_new_with_label("Connect");
                    gtk_widget_add_css_class(btn, "flat");
                    g_signal_connect_data(btn, "clicked", G_CALLBACK(on_connect_clicked),
                                          g_strdup(ssid), (GClosureNotify)g_free, 0);
                    adw_action_row_add_suffix(row, btn);
                }

                adw_preferences_group_add(nw->networks_group, GTK_WIDGET(row));
                nw->network_rows = g_list_append(nw->network_rows, row);
            }
            g_free(ssid);
        }
        g_strfreev(parts);
    }
    g_strfreev(lines);
    g_hash_table_destroy(seen);
}

static void refresh_networks(NetWidgets *nw) {
    run_cmd_async("nmcli -t -f IN-USE,SSID,BARS,SECURITY device wifi list", on_networks_loaded, nw);

    char *act_out = run_cmd("nmcli -t -f TYPE,NAME connection show --active");
    if (act_out) {
        char **lines = g_strsplit(act_out, "\n", -1);
        if (lines[0] && strchr(lines[0], ':')) {
            char **p = g_strsplit(lines[0], ":", 2);
            adw_preferences_row_set_title(ADW_PREFERENCES_ROW(nw->active_row), p[1]);
            char *sub = g_strdup_printf("Connected via %s", p[0]);
            adw_action_row_set_subtitle(nw->active_row, sub);
            g_free(sub);
            adw_action_row_set_icon_name(nw->active_row, "network-wireless-symbolic");
            g_strfreev(p);
        }
        g_strfreev(lines);
        g_free(act_out);
    }
}

static void on_rescan_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn;
    NetWidgets *nw = (NetWidgets *)user_data;
    run_cmd_fire_and_forget("nmcli device wifi rescan");
    refresh_networks(nw);
}

AdwPreferencesPage *create_network_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Wi-Fi & Network");
    adw_preferences_page_set_icon_name(page, "network-wireless-symbolic");
    adw_preferences_page_set_name(page, "network");

    NetWidgets *nw = g_new0(NetWidgets, 1);

    // Wi-Fi switch group
    AdwPreferencesGroup *radio_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(radio_group, "Wireless Radio");
    adw_preferences_page_add(page, radio_group);

    nw->wifi_switch = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(nw->wifi_switch), "Enable Wi-Fi");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(nw->wifi_switch), "Connect to wireless access points");
    adw_action_row_set_icon_name(ADW_ACTION_ROW(nw->wifi_switch), "network-wireless-symbolic");

    char *rad_out = run_cmd("nmcli radio wifi");
    if (rad_out) {
        if (g_strcmp0(rad_out, "enabled") == 0) {
            adw_switch_row_set_active(nw->wifi_switch, TRUE);
        }
        g_free(rad_out);
    }
    g_signal_connect(nw->wifi_switch, "notify::active", G_CALLBACK(on_wifi_toggled), nw);
    adw_preferences_group_add(radio_group, GTK_WIDGET(nw->wifi_switch));

    // Active connection group
    AdwPreferencesGroup *act_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(act_group, "Current Connection");
    adw_preferences_page_add(page, act_group);

    nw->active_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(nw->active_row), "Disconnected");
    adw_action_row_set_subtitle(nw->active_row, "No active internet link");
    adw_action_row_set_icon_name(nw->active_row, "network-offline-symbolic");
    adw_preferences_group_add(act_group, GTK_WIDGET(nw->active_row));

    // Available networks group
    nw->networks_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(nw->networks_group, "Available Access Points");
    GtkWidget *rescan_btn = gtk_button_new_with_label("Rescan");
    gtk_widget_add_css_class(rescan_btn, "flat");
    g_signal_connect(rescan_btn, "clicked", G_CALLBACK(on_rescan_clicked), nw);
    adw_preferences_group_set_header_suffix(nw->networks_group, rescan_btn);
    adw_preferences_page_add(page, nw->networks_group);

    refresh_networks(nw);

    return page;
}
