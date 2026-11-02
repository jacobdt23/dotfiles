#include "power.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>

static void on_profile_selected(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    AdwComboRow *combo = ADW_COMBO_ROW(object);
    guint idx = adw_combo_row_get_selected(combo);
    const char *profiles[] = {"power-saver", "balanced", "performance"};
    if (idx < 3) {
        char *cmd = g_strdup_printf("powerprofilesctl set %s", profiles[idx]);
        run_cmd_fire_and_forget(cmd);
        g_free(cmd);
    }
}

AdwPreferencesPage *create_power_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Power");
    adw_preferences_page_set_icon_name(page, "battery-level-80-symbolic");
    adw_preferences_page_set_name(page, "power");

    // Profile group
    AdwPreferencesGroup *prof_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(prof_group, "Power Profile");
    adw_preferences_group_set_description(prof_group, "Balance hardware performance with energy consumption");
    adw_preferences_page_add(page, prof_group);

    AdwComboRow *combo = ADW_COMBO_ROW(adw_combo_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(combo), "Energy Profile");
    adw_action_row_set_icon_name(ADW_ACTION_ROW(combo), "power-profile-balanced-symbolic");

    const char *items[] = {"Power Saver", "Balanced", "Performance", NULL};
    GtkStringList *model = gtk_string_list_new(items);
    adw_combo_row_set_model(combo, G_LIST_MODEL(model));
    g_object_unref(model);

    char *prof_out = run_cmd("powerprofilesctl get");
    if (prof_out) {
        if (strstr(prof_out, "power-saver")) adw_combo_row_set_selected(combo, 0);
        else if (strstr(prof_out, "performance")) adw_combo_row_set_selected(combo, 2);
        else adw_combo_row_set_selected(combo, 1);
        g_free(prof_out);
    }
    g_signal_connect(combo, "notify::selected", G_CALLBACK(on_profile_selected), NULL);
    adw_preferences_group_add(prof_group, GTK_WIDGET(combo));

    // Battery group
    AdwPreferencesGroup *batt_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(batt_group, "Battery Diagnostic");
    adw_preferences_page_add(page, batt_group);

    AdwActionRow *batt_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(batt_row), "AC Power / Desktop");
    adw_action_row_set_subtitle(batt_row, "Connected to mains power");
    adw_action_row_set_icon_name(batt_row, "ac-adapter-symbolic");

    char *cap_out = run_cmd("cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || cat /sys/class/power_supply/BAT1/capacity 2>/dev/null");
    if (cap_out && strlen(cap_out) > 0) {
        char *stat_out = run_cmd("cat /sys/class/power_supply/BAT0/status 2>/dev/null || cat /sys/class/power_supply/BAT1/status 2>/dev/null");
        char *title = g_strdup_printf("Battery: %s%%", cap_out);
        adw_preferences_row_set_title(ADW_PREFERENCES_ROW(batt_row), title);
        g_free(title);

        if (stat_out) {
            char *sub = g_strdup_printf("State: %s", stat_out);
            adw_action_row_set_subtitle(batt_row, sub);
            g_free(sub);
            g_free(stat_out);
        }
        adw_action_row_set_icon_name(batt_row, "battery-level-80-symbolic");
        g_free(cap_out);
    }
    adw_preferences_group_add(batt_group, GTK_WIDGET(batt_row));

    return page;
}
