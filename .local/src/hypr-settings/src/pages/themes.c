#include "themes.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>

static void on_dark_mode_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char cmd[128];
    snprintf(cmd, sizeof(cmd), "gsettings set org.gnome.desktop.interface color-scheme '%s'",
             active ? "prefer-dark" : "default");
    run_cmd_async(cmd, NULL, NULL);
}

static void on_gtk_theme_selected(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    AdwComboRow *row = ADW_COMBO_ROW(object);
    guint idx = adw_combo_row_get_selected(row);
    const char *themes[] = { "Tokyonight-Dark", "Tokyonight-Dark-hdpi", "Adwaita-dark", "Default" };
    if (idx < G_N_ELEMENTS(themes)) {
        char cmd[256];
        snprintf(cmd, sizeof(cmd), "gsettings set org.gnome.desktop.interface gtk-theme '%s'", themes[idx]);
        run_cmd_async(cmd, NULL, NULL);
    }
}

static void on_icon_theme_selected(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    AdwComboRow *row = ADW_COMBO_ROW(object);
    guint idx = adw_combo_row_get_selected(row);
    const char *icons[] = { "Papirus-Dark", "Papirus", "breeze-dark", "Adwaita" };
    if (idx < G_N_ELEMENTS(icons)) {
        char cmd[256];
        snprintf(cmd, sizeof(cmd), "gsettings set org.gnome.desktop.interface icon-theme '%s'", icons[idx]);
        run_cmd_async(cmd, NULL, NULL);
    }
}

static void on_font_scale_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    double val = adw_spin_row_get_value(ADW_SPIN_ROW(object));
    char cmd[128];
    snprintf(cmd, sizeof(cmd), "gsettings set org.gnome.desktop.interface text-scaling-factor %.2f", val);
    run_cmd_async(cmd, NULL, NULL);
}

GtkWidget *create_themes_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Colors & Themes");
    adw_preferences_page_set_icon_name(page, "preferences-desktop-theme-symbolic");

    // Color Scheme Group
    AdwPreferencesGroup *color_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(color_group, "Color Scheme & Style");
    adw_preferences_group_set_description(color_group, "Configure system dark mode and accent styling");
    adw_preferences_page_add(page, color_group);

    AdwSwitchRow *dark_row = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(dark_row), "Dark Appearance");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(dark_row), "Prefer dark theme across GTK and Wayland applications");
    adw_switch_row_set_active(dark_row, TRUE);
    g_signal_connect(dark_row, "notify::active", G_CALLBACK(on_dark_mode_toggled), NULL);
    adw_preferences_group_add(color_group, GTK_WIDGET(dark_row));

    // Application Themes
    AdwPreferencesGroup *theme_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(theme_group, "Application Themes & Typography");
    adw_preferences_group_set_description(theme_group, "Widget themes, icon packs, and text scaling");
    adw_preferences_page_add(page, theme_group);

    // GTK Theme
    const char *gtk_items[] = { "Tokyonight-Dark", "Tokyonight-Dark-hdpi", "Adwaita-dark", "Default", NULL };
    GtkStringList *gtk_model = gtk_string_list_new(gtk_items);
    AdwComboRow *gtk_row = ADW_COMBO_ROW(adw_combo_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(gtk_row), "GTK Application Theme");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(gtk_row), "Visual styling for GTK3 and GTK4 windows");
    adw_combo_row_set_model(gtk_row, G_LIST_MODEL(gtk_model));
    adw_combo_row_set_selected(gtk_row, 0);
    g_signal_connect(gtk_row, "notify::selected", G_CALLBACK(on_gtk_theme_selected), NULL);
    adw_preferences_group_add(theme_group, GTK_WIDGET(gtk_row));

    // Icon Theme
    const char *icon_items[] = { "Papirus-Dark", "Papirus", "breeze-dark", "Adwaita", NULL };
    GtkStringList *icon_model = gtk_string_list_new(icon_items);
    AdwComboRow *icon_row = ADW_COMBO_ROW(adw_combo_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(icon_row), "System Icon Theme");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(icon_row), "Icon set for file managers, launchers, and panels");
    adw_combo_row_set_model(icon_row, G_LIST_MODEL(icon_model));
    adw_combo_row_set_selected(icon_row, 0);
    g_signal_connect(icon_row, "notify::selected", G_CALLBACK(on_icon_theme_selected), NULL);
    adw_preferences_group_add(theme_group, GTK_WIDGET(icon_row));

    // Font Scale
    AdwSpinRow *font_row = ADW_SPIN_ROW(adw_spin_row_new_with_range(0.80, 1.60, 0.05));
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(font_row), "Font Text Scaling");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(font_row), "Global magnification multiplier for UI labels");
    adw_spin_row_set_value(font_row, 1.00);
    adw_spin_row_set_digits(font_row, 2);
    g_signal_connect(font_row, "notify::value", G_CALLBACK(on_font_scale_changed), NULL);
    adw_preferences_group_add(theme_group, GTK_WIDGET(font_row));

    return GTK_WIDGET(page);
}
