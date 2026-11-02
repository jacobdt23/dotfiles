#include "wallpaper.h"
#include "../utils/command.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void on_open_waypaper(GtkButton *btn, gpointer user_data) {
    (void)btn; (void)user_data;
    run_cmd_async("waypaper", NULL, NULL);
}

static void on_apply_wallpaper(GtkButton *btn, gpointer user_data) {
    (void)btn;
    const char *path = (const char *)user_data;
    if (path) {
        char cmd[512];
        snprintf(cmd, sizeof(cmd), "waypaper --wallpaper '%s' 2>/dev/null || swww img '%s' 2>/dev/null", path, path);
        run_cmd_async(cmd, NULL, NULL);
    }
}

GtkWidget *create_wallpaper_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Wallpaper & Background");
    adw_preferences_page_set_icon_name(page, "preferences-desktop-wallpaper-symbolic");

    // Waypaper Manager Group
    AdwPreferencesGroup *mgr_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(mgr_group, "Wallpaper Manager");
    adw_preferences_group_set_description(mgr_group, "Manage monitor backgrounds and multi-screen wallpapers");
    adw_preferences_page_add(page, mgr_group);

    AdwActionRow *waypaper_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(waypaper_row), "Waypaper GUI");
    adw_action_row_set_subtitle(waypaper_row, "Launch interactive wallpaper gallery and transition picker");
    GtkWidget *wp_btn = gtk_button_new_with_label("Open Waypaper");
    gtk_widget_add_css_class(wp_btn, "suggested-action");
    gtk_widget_set_valign(wp_btn, GTK_ALIGN_CENTER);
    g_signal_connect(wp_btn, "clicked", G_CALLBACK(on_open_waypaper), NULL);
    adw_action_row_add_suffix(waypaper_row, wp_btn);
    adw_preferences_group_add(mgr_group, GTK_WIDGET(waypaper_row));

    // Available Wallpapers Group
    AdwPreferencesGroup *list_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(list_group, "Discovered Wallpapers");
    adw_preferences_group_set_description(list_group, "Quickly apply backgrounds from ~/Pictures/Wallpapers");
    adw_preferences_page_add(page, list_group);

    const char *home = getenv("HOME");
    char wp_dir[512];
    snprintf(wp_dir, sizeof(wp_dir), "%s/Pictures/Wallpapers", home ? home : "/home/jacob");

    GDir *dir = g_dir_open(wp_dir, 0, NULL);
    gboolean found = FALSE;
    if (dir) {
        const gchar *filename;
        while ((filename = g_dir_read_name(dir)) != NULL) {
            if (g_str_has_suffix(filename, ".png") || g_str_has_suffix(filename, ".jpg") ||
                g_str_has_suffix(filename, ".jpeg") || g_str_has_suffix(filename, ".webp")) {
                found = TRUE;
                char fullpath[1024];
                snprintf(fullpath, sizeof(fullpath), "%s/%s", wp_dir, filename);

                AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
                adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), filename);
                adw_action_row_set_subtitle(row, fullpath);

                GtkWidget *apply_btn = gtk_button_new_with_label("Set as Wallpaper");
                gtk_widget_set_valign(apply_btn, GTK_ALIGN_CENTER);
                g_signal_connect_data(apply_btn, "clicked", G_CALLBACK(on_apply_wallpaper),
                                      g_strdup(fullpath), (GClosureNotify)g_free, 0);
                adw_action_row_add_suffix(row, apply_btn);
                adw_preferences_group_add(list_group, GTK_WIDGET(row));
            }
        }
        g_dir_close(dir);
    }

    if (!found) {
        AdwActionRow *empty_row = ADW_ACTION_ROW(adw_action_row_new());
        adw_preferences_row_set_title(ADW_PREFERENCES_ROW(empty_row), "No wallpapers found");
        adw_action_row_set_subtitle(empty_row, "Add .png or .jpg files to ~/Pictures/Wallpapers/");
        adw_preferences_group_add(list_group, GTK_WIDGET(empty_row));
    }

    return GTK_WIDGET(page);
}
