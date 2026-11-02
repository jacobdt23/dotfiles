#include "appearance.h"
#include "../utils/hyprctl.h"
#include <stdio.h>

static void on_gaps_in_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    int val = (int)adw_spin_row_get_value(ADW_SPIN_ROW(object));
    hyprctl_set_int("general:gaps_in", val);
}

static void on_gaps_out_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    int val = (int)adw_spin_row_get_value(ADW_SPIN_ROW(object));
    hyprctl_set_int("general:gaps_out", val);
}

static void on_border_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    int val = (int)adw_spin_row_get_value(ADW_SPIN_ROW(object));
    hyprctl_set_int("general:border_size", val);
}

static void on_rounding_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    int val = (int)adw_spin_row_get_value(ADW_SPIN_ROW(object));
    hyprctl_set_int("decoration:rounding", val);
}

static void on_blur_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean val = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    hyprctl_set("decoration:blur:enabled", val ? "true" : "false");
}

static void on_shadow_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean val = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    hyprctl_set("decoration:shadow:enabled", val ? "true" : "false");
}

static void on_anim_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean val = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    hyprctl_set("animations:enabled", val ? "true" : "false");
}

AdwPreferencesPage *create_appearance_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Appearance");
    adw_preferences_page_set_icon_name(page, "preferences-desktop-theme-symbolic");
    adw_preferences_page_set_name(page, "appearance");

    // Gaps group
    AdwPreferencesGroup *gaps_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(gaps_group, "Gaps & Spacing");
    adw_preferences_group_set_description(gaps_group, "Tiling window gaps and screen edge padding");
    adw_preferences_page_add(page, gaps_group);

    AdwSpinRow *gaps_in_row = ADW_SPIN_ROW(adw_spin_row_new_with_range(0, 30, 1));
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(gaps_in_row), "Inner Window Gaps");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(gaps_in_row), "Space between tiled windows (pixels)");
    adw_spin_row_set_value(gaps_in_row, 5);
    g_signal_connect(gaps_in_row, "notify::value", G_CALLBACK(on_gaps_in_changed), NULL);
    adw_preferences_group_add(gaps_group, GTK_WIDGET(gaps_in_row));

    AdwSpinRow *gaps_out_row = ADW_SPIN_ROW(adw_spin_row_new_with_range(0, 50, 1));
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(gaps_out_row), "Outer Screen Gaps");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(gaps_out_row), "Space between windows and monitor screen edges");
    adw_spin_row_set_value(gaps_out_row, 10);
    g_signal_connect(gaps_out_row, "notify::value", G_CALLBACK(on_gaps_out_changed), NULL);
    adw_preferences_group_add(gaps_group, GTK_WIDGET(gaps_out_row));

    AdwSpinRow *border_row = ADW_SPIN_ROW(adw_spin_row_new_with_range(0, 8, 1));
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(border_row), "Border Width");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(border_row), "Outline thickness around active and inactive windows");
    adw_spin_row_set_value(border_row, 2);
    g_signal_connect(border_row, "notify::value", G_CALLBACK(on_border_changed), NULL);
    adw_preferences_group_add(gaps_group, GTK_WIDGET(border_row));

    // Corners & Effects
    AdwPreferencesGroup *decor_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(decor_group, "Corners & Effects");
    adw_preferences_group_set_description(decor_group, "Corner curvature, transparency blur, and shadows");
    adw_preferences_page_add(page, decor_group);

    AdwSpinRow *round_row = ADW_SPIN_ROW(adw_spin_row_new_with_range(0, 25, 1));
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(round_row), "Corner Rounding");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(round_row), "Window corner radius (pixels)");
    adw_spin_row_set_value(round_row, 10);
    g_signal_connect(round_row, "notify::value", G_CALLBACK(on_rounding_changed), NULL);
    adw_preferences_group_add(decor_group, GTK_WIDGET(round_row));

    AdwSwitchRow *blur_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(blur_row), "Background Blur");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(blur_row), "Frosted glass blur effect behind transparent windows");
    adw_switch_row_set_active(blur_row, TRUE);
    g_signal_connect(blur_row, "notify::active", G_CALLBACK(on_blur_toggled), NULL);
    adw_preferences_group_add(decor_group, GTK_WIDGET(blur_row));

    AdwSwitchRow *shadow_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(shadow_row), "Window Shadows");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(shadow_row), "Depth shadows under active and floating windows");
    adw_switch_row_set_active(shadow_row, TRUE);
    g_signal_connect(shadow_row, "notify::active", G_CALLBACK(on_shadow_toggled), NULL);
    adw_preferences_group_add(decor_group, GTK_WIDGET(shadow_row));

    AdwSwitchRow *anim_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(anim_row), "Dynamic Animations");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(anim_row), "Window slide, fade, and workspace switching animations");
    adw_switch_row_set_active(anim_row, TRUE);
    g_signal_connect(anim_row, "notify::active", G_CALLBACK(on_anim_toggled), NULL);
    adw_preferences_group_add(decor_group, GTK_WIDGET(anim_row));

    return page;
}
