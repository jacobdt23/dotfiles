#include <adwaita.h>
#include "pages/bluetooth.h"
#include "pages/network.h"
#include "pages/audio.h"
#include "pages/displays.h"
#include "pages/appearance.h"
#include "pages/input.h"
#include "pages/power.h"
#include "pages/about.h"

static void app_activate(GApplication *app, gpointer user_data) {
    (void)user_data;
    GtkWindow *win = gtk_application_get_active_window(GTK_APPLICATION(app));

    if (!win) {
        win = GTK_WINDOW(adw_preferences_window_new());
        gtk_window_set_application(win, GTK_APPLICATION(app));
        gtk_window_set_title(win, "Settings");
        gtk_window_set_default_size(win, 950, 660);

        // Add modular pages
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_bluetooth_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_network_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_audio_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_displays_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_appearance_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_input_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_power_page());
        adw_preferences_window_add(ADW_PREFERENCES_WINDOW(win), create_about_page());
    }

    gtk_window_present(win);
}

int main(int argc, char **argv) {
    AdwApplication *app = adw_application_new("io.github.hyprsettings", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(app_activate), NULL);

    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);

    return status;
}
