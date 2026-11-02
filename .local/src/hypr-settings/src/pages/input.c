#include "input.h"
#include "../utils/hyprctl.h"
#include <stdio.h>

static void on_sens_changed(GtkRange *range, gpointer user_data) {
    (void)user_data;
    double val = gtk_range_get_value(range) / 100.0;
    hyprctl_set_float("input:sensitivity", val);
}

static void on_natural_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean val = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    hyprctl_set("input:touchpad:natural_scroll", val ? "true" : "false");
}

static void on_tap_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean val = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    hyprctl_set("input:touchpad:tap-to-click", val ? "true" : "false");
}

static void on_repeat_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    int val = (int)adw_spin_row_get_value(ADW_SPIN_ROW(object));
    hyprctl_set_int("input:repeat_rate", val);
}

AdwPreferencesPage *create_input_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Mouse & Touchpad");
    adw_preferences_page_set_icon_name(page, "input-mouse-symbolic");
    adw_preferences_page_set_name(page, "input");

    // Pointer group
    AdwPreferencesGroup *mouse_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(mouse_group, "Pointer & Cursor");
    adw_preferences_page_add(page, mouse_group);

    AdwActionRow *sens_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(sens_row), "Pointer Speed");
    adw_action_row_set_subtitle(sens_row, "Cursor acceleration and tracking sensitivity");

    GtkScale *sens_scale = GTK_SCALE(gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, -100, 100, 5));
    gtk_widget_set_size_request(GTK_WIDGET(sens_scale), 180, -1);
    gtk_range_set_value(GTK_RANGE(sens_scale), 0);
    g_signal_connect(sens_scale, "value-changed", G_CALLBACK(on_sens_changed), NULL);
    adw_action_row_add_suffix(sens_row, GTK_WIDGET(sens_scale));
    adw_preferences_group_add(mouse_group, GTK_WIDGET(sens_row));

    // Touchpad group
    AdwPreferencesGroup *touch_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(touch_group, "Touchpad Gestures");
    adw_preferences_page_add(page, touch_group);

    AdwSwitchRow *nat_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(nat_row), "Natural Scrolling");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(nat_row), "Content follows finger movement direction");
    g_signal_connect(nat_row, "notify::active", G_CALLBACK(on_natural_toggled), NULL);
    adw_preferences_group_add(touch_group, GTK_WIDGET(nat_row));

    AdwSwitchRow *tap_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(tap_row), "Tap to Click");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(tap_row), "Tap on touchpad acts as primary click");
    adw_switch_row_set_active(tap_row, TRUE);
    g_signal_connect(tap_row, "notify::active", G_CALLBACK(on_tap_toggled), NULL);
    adw_preferences_group_add(touch_group, GTK_WIDGET(tap_row));

    // Keyboard group
    AdwPreferencesGroup *kb_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(kb_group, "Keyboard Typing");
    adw_preferences_page_add(page, kb_group);

    AdwSpinRow *rep_row = ADW_SPIN_ROW(adw_spin_row_new_with_range(10, 60, 1));
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(rep_row), "Key Repeat Rate");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(rep_row), "Repeats per second when holding down a key");
    adw_spin_row_set_value(rep_row, 25);
    g_signal_connect(rep_row, "notify::value", G_CALLBACK(on_repeat_changed), NULL);
    adw_preferences_group_add(kb_group, GTK_WIDGET(rep_row));

    return page;
}
