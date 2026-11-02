#include "shortcuts.h"

typedef struct {
    const char *key;
    const char *desc;
    const char *category;
} ShortcutEntry;

static const ShortcutEntry SHORTCUTS[] = {
    // Window Management & Applications
    { "Super + Return", "Launch Kitty GPU-accelerated terminal", "Applications" },
    { "Super + E", "Open Thunar file manager", "Applications" },
    { "Super + D", "Launch Discord messenger", "Applications" },
    { "Super + I", "Open System Settings Control Center", "Applications" },
    { "Super + C", "Close currently focused window", "Window Management" },
    { "Super + F", "Toggle fullscreen for active window", "Window Management" },
    { "Super + V", "Toggle floating mode for window", "Window Management" },

    // Desktop Shell & Menus
    { "Super (Tap)", "Toggle Application Launcher menu", "Jacob Shell" },
    { "Super + Q", "Open Power & Session logout menu", "Jacob Shell" },
    { "Super + N", "Open Notification Center panel", "Jacob Shell" },
    { "Super + M", "Open Media Player controller", "Jacob Shell" },
    { "Super + K", "Display Keybindings quick cheat sheet", "Jacob Shell" },
    { "Super + L", "Open Calendar & Agenda flyout", "Jacob Shell" },
    { "Super + Shift + V", "Open Clipboard history popup", "Jacob Shell" },

    // System Control
    { "Super + Shift + R", "Reload Hyprland compositor configuration", "System Control" },
    { "Super + Equal (=)", "Increase PipeWire master audio volume by 5%", "System Control" },
    { "Super + Minus (-)", "Decrease PipeWire master audio volume by 5%", "System Control" },
    { "Super + BackSpace", "Toggle audio mute on / off", "System Control" },
};

GtkWidget *create_shortcuts_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Shortcuts & Keybindings");
    adw_preferences_page_set_icon_name(page, "preferences-desktop-keyboard-shortcuts-symbolic");

    const char *current_cat = NULL;
    AdwPreferencesGroup *current_group = NULL;

    for (size_t i = 0; i < G_N_ELEMENTS(SHORTCUTS); i++) {
        if (!current_cat || g_strcmp0(current_cat, SHORTCUTS[i].category) != 0) {
            current_cat = SHORTCUTS[i].category;
            current_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
            adw_preferences_group_set_title(current_group, current_cat);
            adw_preferences_page_add(page, current_group);
        }

        AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
        adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), SHORTCUTS[i].desc);

        // Badge label for the shortcut combination
        GtkWidget *badge = gtk_label_new(SHORTCUTS[i].key);
        gtk_widget_add_css_class(badge, "kde-shortcut-badge");
        gtk_widget_set_valign(badge, GTK_ALIGN_CENTER);

        adw_action_row_add_suffix(row, badge);
        adw_preferences_group_add(current_group, GTK_WIDGET(row));
    }

    return GTK_WIDGET(page);
}
