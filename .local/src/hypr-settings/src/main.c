#include <adwaita.h>
#include <glib.h>
#include <stdio.h>
#include <string.h>

#include "pages/about.h"
#include "pages/appearance.h"
#include "pages/audio.h"
#include "pages/bluetooth.h"
#include "pages/defaultapps.h"
#include "pages/displays.h"
#include "pages/input.h"
#include "pages/network.h"
#include "pages/power.h"
#include "pages/shortcuts.h"
#include "pages/themes.h"
#include "pages/wallpaper.h"
#include "utils/command.h"
#include "utils/hyprctl.h"

typedef struct {
    const char *id;
    const char *name;
    const char *icon;
    const char *section;
    GtkWidget *(*create_fn)(void);
} PageDef;

static const PageDef PAGES[] = {
    // CONNECTIVITY
    { "bluetooth", "Bluetooth", "bluetooth-active-symbolic", "CONNECTIVITY", (GtkWidget *(*)(void))create_bluetooth_page },
    { "network", "Wi-Fi & Connections", "network-wireless-symbolic", "CONNECTIVITY", (GtkWidget *(*)(void))create_network_page },

    // HARDWARE
    { "displays", "Display and Monitor", "video-display-symbolic", "HARDWARE", (GtkWidget *(*)(void))create_displays_page },
    { "audio", "Audio", "audio-volume-high-symbolic", "HARDWARE", (GtkWidget *(*)(void))create_audio_page },
    { "power", "Power Management", "battery-symbolic", "HARDWARE", (GtkWidget *(*)(void))create_power_page },

    // PERSONALIZATION
    { "themes", "Colors & Themes", "preferences-desktop-theme-symbolic", "PERSONALIZATION", create_themes_page },
    { "appearance", "Window Effects & Look", "preferences-system-windows-symbolic", "PERSONALIZATION", (GtkWidget *(*)(void))create_appearance_page },
    { "wallpaper", "Wallpaper & Background", "preferences-desktop-wallpaper-symbolic", "PERSONALIZATION", create_wallpaper_page },

    // WORKSPACE & INPUT
    { "input", "Mouse & Touchpad", "input-mouse-symbolic", "WORKSPACE & INPUT", (GtkWidget *(*)(void))create_input_page },
    { "shortcuts", "Shortcuts & Keybindings", "preferences-desktop-keyboard-shortcuts-symbolic", "WORKSPACE & INPUT", create_shortcuts_page },
    { "defaultapps", "Default Applications", "system-run-symbolic", "WORKSPACE & INPUT", create_defaultapps_page },

    // SYSTEM
    { "about", "About this System", "help-about-symbolic", "SYSTEM", (GtkWidget *(*)(void))create_about_page },
};

typedef struct {
    GtkWidget *stack;
    GtkWidget *sec_label;
    GtkWidget *cur_label;
    GtkWidget *search_entry;
    GtkWidget *list_box;
    int active_idx;
} AppWidgets;

static gboolean filter_sidebar_row(GtkListBoxRow *row, gpointer user_data) {
    const char *search_text = gtk_editable_get_text(GTK_EDITABLE(user_data));
    if (!search_text || *search_text == '\0') {
        return TRUE;
    }

    gpointer data = g_object_get_data(G_OBJECT(row), "page_idx");
    if (!data) return FALSE; // header rows hidden during search

    int idx = GPOINTER_TO_INT(data) - 1;
    if (idx < 0 || (size_t)idx >= G_N_ELEMENTS(PAGES)) return FALSE;

    gchar *q = g_utf8_casefold(search_text, -1);
    gchar *name = g_utf8_casefold(PAGES[idx].name, -1);
    gchar *sec = g_utf8_casefold(PAGES[idx].section, -1);

    gboolean matches = (strstr(name, q) != NULL) || (strstr(sec, q) != NULL);

    g_free(q);
    g_free(name);
    g_free(sec);

    return matches;
}

static void on_search_changed(GtkSearchEntry *entry, gpointer user_data) {
    (void)entry;
    GtkListBox *list_box = GTK_LIST_BOX(user_data);
    gtk_list_box_invalidate_filter(list_box);
}

static void on_row_activated(GtkListBox *box, GtkListBoxRow *row, gpointer user_data) {
    (void)box;
    AppWidgets *app = (AppWidgets *)user_data;
    gpointer data = g_object_get_data(G_OBJECT(row), "page_idx");
    if (!data) return;

    int idx = GPOINTER_TO_INT(data) - 1;
    if (idx < 0 || (size_t)idx >= G_N_ELEMENTS(PAGES)) return;

    app->active_idx = idx;
    gtk_stack_set_visible_child_name(GTK_STACK(app->stack), PAGES[idx].id);

    gtk_label_set_text(GTK_LABEL(app->sec_label), PAGES[idx].section);
    gtk_label_set_text(GTK_LABEL(app->cur_label), PAGES[idx].name);
}

static void on_defaults_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn; (void)user_data;
    hyprctl_set_int("general:gaps_in", 5);
    hyprctl_set_int("general:gaps_out", 10);
    hyprctl_set_int("general:border_size", 2);
    hyprctl_set_int("decoration:rounding", 10);
    hyprctl_set("decoration:blur:enabled", "true");
    hyprctl_set("decoration:shadow:enabled", "true");
    hyprctl_set("animations:enabled", "true");
    hyprctl_set_float("input:sensitivity", 0.0);
    run_cmd_async("notify-send -a 'System Settings' 'Defaults Restored' 'Hyprland layout defaults have been applied.'", NULL, NULL);
}

static void on_discard_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn; (void)user_data;
    run_cmd_async("hyprctl reload && notify-send -a 'System Settings' 'Changes Discarded' 'Reloaded compositor configuration from disk.'", NULL, NULL);
}

static void on_apply_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn; (void)user_data;
    run_cmd_async("notify-send -a 'System Settings' 'Settings Applied' 'All active configuration changes are live.'", NULL, NULL);
}

static void app_activate(GApplication *gapp, gpointer user_data) {
    (void)user_data;
    GtkWindow *existing = gtk_application_get_active_window(GTK_APPLICATION(gapp));
    if (existing) {
        gtk_window_present(existing);
        return;
    }

    // Load custom KDE Plasma 6 Breeze style
    GtkCssProvider *css = gtk_css_provider_new();
    const char *home = getenv("HOME");
    char css_path[512];
    snprintf(css_path, sizeof(css_path), "%s/.local/src/hypr-settings/src/style.css", home ? home : "/home/jacob");
    if (!g_file_test(css_path, G_FILE_TEST_EXISTS)) {
        snprintf(css_path, sizeof(css_path), "%s/.local/share/hypr-settings/style.css", home ? home : "/home/jacob");
    }
    if (g_file_test(css_path, G_FILE_TEST_EXISTS)) {
        gtk_css_provider_load_from_path(css, css_path);
        GdkDisplay *disp = gdk_display_get_default();
        if (disp) {
            gtk_style_context_add_provider_for_display(disp,
                                                      GTK_STYLE_PROVIDER(css),
                                                      GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
        }
    }

    AdwApplicationWindow *win = ADW_APPLICATION_WINDOW(adw_application_window_new(GTK_APPLICATION(gapp)));
    gtk_window_set_title(GTK_WINDOW(win), "System Settings");
    gtk_window_set_default_size(GTK_WINDOW(win), 1020, 700);

    AppWidgets *widgets = g_new0(AppWidgets, 1);

    // Root Horizontal Layout
    GtkWidget *root_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    adw_application_window_set_content(win, root_box);

    // ==========================================
    // 1. LEFT SIDEBAR (KDE Plasma 6 style)
    // ==========================================
    GtkWidget *sidebar = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_widget_add_css_class(sidebar, "kde-sidebar");
    gtk_widget_set_size_request(sidebar, 260, -1);
    gtk_box_append(GTK_BOX(root_box), sidebar);

    // Search bar
    widgets->search_entry = gtk_search_entry_new();
    gtk_widget_add_css_class(widgets->search_entry, "kde-search");
    gtk_box_append(GTK_BOX(sidebar), widgets->search_entry);

    // Scrolled navigation list
    GtkWidget *scroll_nav = gtk_scrolled_window_new();
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scroll_nav), GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC);
    gtk_widget_set_vexpand(scroll_nav, TRUE);
    gtk_box_append(GTK_BOX(sidebar), scroll_nav);

    widgets->list_box = gtk_list_box_new();
    gtk_widget_add_css_class(widgets->list_box, "kde-sidebar-list");
    gtk_list_box_set_selection_mode(GTK_LIST_BOX(widgets->list_box), GTK_SELECTION_SINGLE);
    gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(scroll_nav), widgets->list_box);

    gtk_list_box_set_filter_func(GTK_LIST_BOX(widgets->list_box), filter_sidebar_row, widgets->search_entry, NULL);
    g_signal_connect(widgets->search_entry, "search-changed", G_CALLBACK(on_search_changed), widgets->list_box);

    // Build sidebar items
    const char *last_section = NULL;
    GtkListBoxRow *first_selectable_row = NULL;

    for (size_t i = 0; i < G_N_ELEMENTS(PAGES); i++) {
        // Section Header
        if (!last_section || strcmp(last_section, PAGES[i].section) != 0) {
            last_section = PAGES[i].section;

            GtkWidget *header_row = gtk_list_box_row_new();
            gtk_list_box_row_set_selectable(GTK_LIST_BOX_ROW(header_row), FALSE);
            gtk_list_box_row_set_activatable(GTK_LIST_BOX_ROW(header_row), FALSE);

            GtkWidget *header_lbl = gtk_label_new(last_section);
            gtk_widget_add_css_class(header_lbl, "kde-category-header");
            gtk_widget_set_halign(header_lbl, GTK_ALIGN_START);
            gtk_list_box_row_set_child(GTK_LIST_BOX_ROW(header_row), header_lbl);

            gtk_list_box_append(GTK_LIST_BOX(widgets->list_box), header_row);
        }

        // Page Row
        GtkWidget *row = gtk_list_box_row_new();
        gtk_widget_add_css_class(row, "kde-sidebar-row");
        g_object_set_data(G_OBJECT(row), "page_idx", GINT_TO_POINTER((int)i + 1));

        GtkWidget *row_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
        GtkWidget *icon = gtk_image_new_from_icon_name(PAGES[i].icon);
        gtk_image_set_pixel_size(GTK_IMAGE(icon), 18);
        gtk_box_append(GTK_BOX(row_box), icon);

        GtkWidget *lbl = gtk_label_new(PAGES[i].name);
        gtk_widget_set_halign(lbl, GTK_ALIGN_START);
        gtk_widget_set_hexpand(lbl, TRUE);
        gtk_box_append(GTK_BOX(row_box), lbl);

        gtk_list_box_row_set_child(GTK_LIST_BOX_ROW(row), row_box);
        gtk_list_box_append(GTK_LIST_BOX(widgets->list_box), row);

        if (!first_selectable_row) {
            first_selectable_row = GTK_LIST_BOX_ROW(row);
        }
    }

    g_signal_connect(widgets->list_box, "row-activated", G_CALLBACK(on_row_activated), widgets);

    // ==========================================
    // 2. RIGHT MAIN CONTENT PANE
    // ==========================================
    GtkWidget *content_pane = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_widget_add_css_class(content_pane, "kde-content");
    gtk_widget_set_hexpand(content_pane, TRUE);
    gtk_box_append(GTK_BOX(root_box), content_pane);

    // Breadcrumb Navigation Header
    GtkWidget *breadcrumb_bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4);
    gtk_widget_add_css_class(breadcrumb_bar, "kde-breadcrumb-bar");
    gtk_box_append(GTK_BOX(content_pane), breadcrumb_bar);

    GtkWidget *root_lbl = gtk_label_new("System Settings");
    gtk_widget_add_css_class(root_lbl, "kde-breadcrumb-root");
    gtk_box_append(GTK_BOX(breadcrumb_bar), root_lbl);

    GtkWidget *sep1 = gtk_label_new(">");
    gtk_widget_add_css_class(sep1, "kde-breadcrumb-sep");
    gtk_box_append(GTK_BOX(breadcrumb_bar), sep1);

    widgets->sec_label = gtk_label_new(PAGES[0].section);
    gtk_widget_add_css_class(widgets->sec_label, "kde-breadcrumb-sec");
    gtk_box_append(GTK_BOX(breadcrumb_bar), widgets->sec_label);

    GtkWidget *sep2 = gtk_label_new(">");
    gtk_widget_add_css_class(sep2, "kde-breadcrumb-sep");
    gtk_box_append(GTK_BOX(breadcrumb_bar), sep2);

    widgets->cur_label = gtk_label_new(PAGES[0].name);
    gtk_widget_add_css_class(widgets->cur_label, "kde-breadcrumb-cur");
    gtk_box_append(GTK_BOX(breadcrumb_bar), widgets->cur_label);

    // Main Page Stack
    widgets->stack = gtk_stack_new();
    gtk_stack_set_transition_type(GTK_STACK(widgets->stack), GTK_STACK_TRANSITION_TYPE_CROSSFADE);
    gtk_stack_set_transition_duration(GTK_STACK(widgets->stack), 150);

    for (size_t i = 0; i < G_N_ELEMENTS(PAGES); i++) {
        GtkWidget *page_widget = PAGES[i].create_fn();
        gtk_stack_add_named(GTK_STACK(widgets->stack), page_widget, PAGES[i].id);
    }

    GtkWidget *scroll_content = gtk_scrolled_window_new();
    gtk_widget_set_vexpand(scroll_content, TRUE);
    gtk_widget_set_hexpand(scroll_content, TRUE);
    gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(scroll_content), widgets->stack);
    gtk_box_append(GTK_BOX(content_pane), scroll_content);

    // ==========================================
    // 3. BOTTOM ACTION BAR (KDE Plasma Signature)
    // ==========================================
    GtkWidget *bottom_bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 12);
    gtk_widget_add_css_class(bottom_bar, "kde-bottom-bar");
    gtk_box_append(GTK_BOX(content_pane), bottom_bar);

    GtkWidget *def_btn = gtk_button_new_with_label("Defaults");
    gtk_widget_add_css_class(def_btn, "kde-btn");
    g_signal_connect(def_btn, "clicked", G_CALLBACK(on_defaults_clicked), NULL);
    gtk_box_append(GTK_BOX(bottom_bar), def_btn);

    GtkWidget *spacer = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    gtk_widget_set_hexpand(spacer, TRUE);
    gtk_box_append(GTK_BOX(bottom_bar), spacer);

    GtkWidget *disc_btn = gtk_button_new_with_label("Discard");
    gtk_widget_add_css_class(disc_btn, "kde-btn");
    g_signal_connect(disc_btn, "clicked", G_CALLBACK(on_discard_clicked), NULL);
    gtk_box_append(GTK_BOX(bottom_bar), disc_btn);

    GtkWidget *apply_btn = gtk_button_new_with_label("Apply");
    gtk_widget_add_css_class(apply_btn, "kde-btn");
    gtk_widget_add_css_class(apply_btn, "kde-btn-primary");
    g_signal_connect(apply_btn, "clicked", G_CALLBACK(on_apply_clicked), NULL);
    gtk_box_append(GTK_BOX(bottom_bar), apply_btn);

    // Select first row initially
    if (first_selectable_row) {
        gtk_list_box_select_row(GTK_LIST_BOX(widgets->list_box), first_selectable_row);
    }

    gtk_window_present(GTK_WINDOW(win));
}

int main(int argc, char **argv) {
    AdwApplication *app = adw_application_new("io.github.hyprsettings", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(app_activate), NULL);

    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
