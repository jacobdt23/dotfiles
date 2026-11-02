#include "defaultapps.h"
#include "../utils/command.h"
#include <stdio.h>

static void on_browser_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    AdwComboRow *row = ADW_COMBO_ROW(object);
    guint idx = adw_combo_row_get_selected(row);
    const char *browsers[] = { "firefox.desktop", "google-chrome.desktop", "chromium.desktop", "brave-browser.desktop" };
    if (idx < G_N_ELEMENTS(browsers)) {
        char cmd[256];
        snprintf(cmd, sizeof(cmd), "xdg-settings set default-web-browser %s", browsers[idx]);
        run_cmd_async(cmd, NULL, NULL);
    }
}

static void on_filemgr_changed(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec; (void)user_data;
    AdwComboRow *row = ADW_COMBO_ROW(object);
    guint idx = adw_combo_row_get_selected(row);
    const char *filemgrs[] = { "thunar.desktop", "org.kde.dolphin.desktop", "nautilus.desktop" };
    if (idx < G_N_ELEMENTS(filemgrs)) {
        char cmd[256];
        snprintf(cmd, sizeof(cmd), "xdg-mime default %s inode/directory", filemgrs[idx]);
        run_cmd_async(cmd, NULL, NULL);
    }
}

GtkWidget *create_defaultapps_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Default Applications");
    adw_preferences_page_set_icon_name(page, "system-run-symbolic");

    AdwPreferencesGroup *group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(group, "Standard Application Handlers");
    adw_preferences_group_set_description(group, "Default programs assigned to open standard URLs and file types");
    adw_preferences_page_add(page, group);

    // Web Browser
    const char *b_items[] = { "Mozilla Firefox", "Google Chrome", "Chromium", "Brave Browser", NULL };
    GtkStringList *b_model = gtk_string_list_new(b_items);
    AdwComboRow *b_row = ADW_COMBO_ROW(adw_combo_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(b_row), "Default Web Browser");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(b_row), "Handler for http:// and https:// internet links");
    adw_combo_row_set_model(b_row, G_LIST_MODEL(b_model));
    adw_combo_row_set_selected(b_row, 0);
    g_signal_connect(b_row, "notify::selected", G_CALLBACK(on_browser_changed), NULL);
    adw_preferences_group_add(group, GTK_WIDGET(b_row));

    // File Manager
    const char *fm_items[] = { "Thunar File Manager", "Dolphin", "Files (Nautilus)", NULL };
    GtkStringList *fm_model = gtk_string_list_new(fm_items);
    AdwComboRow *fm_row = ADW_COMBO_ROW(adw_combo_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(fm_row), "Default File Manager");
    adw_action_row_set_subtitle(ADW_ACTION_ROW(fm_row), "Handler for folders and local file system paths");
    adw_combo_row_set_model(fm_row, G_LIST_MODEL(fm_model));
    adw_combo_row_set_selected(fm_row, 0);
    g_signal_connect(fm_row, "notify::selected", G_CALLBACK(on_filemgr_changed), NULL);
    adw_preferences_group_add(group, GTK_WIDGET(fm_row));

    // Terminal Emulator
    AdwActionRow *term_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(term_row), "Default Terminal Emulator");
    adw_action_row_set_subtitle(term_row, "kitty 0.49.2 (GPU-accelerated terminal)");
    GtkWidget *term_badge = gtk_label_new("Active");
    gtk_widget_add_css_class(term_badge, "kde-active-badge");
    gtk_widget_set_valign(term_badge, GTK_ALIGN_CENTER);
    adw_action_row_add_suffix(term_row, term_badge);
    adw_preferences_group_add(group, GTK_WIDGET(term_row));

    // Text Editor
    AdwActionRow *ed_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(ed_row), "Default Text & Code Editor");
    adw_action_row_set_subtitle(ed_row, "Neovim (Terminal CLI) & Nano");
    GtkWidget *ed_badge = gtk_label_new("Configured");
    gtk_widget_add_css_class(ed_badge, "kde-active-badge");
    gtk_widget_set_valign(ed_badge, GTK_ALIGN_CENTER);
    adw_action_row_add_suffix(ed_row, ed_badge);
    adw_preferences_group_add(group, GTK_WIDGET(ed_row));

    return GTK_WIDGET(page);
}
