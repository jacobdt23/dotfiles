#include "audio.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>

typedef struct {
    GtkScale *out_scale;
    AdwSwitchRow *out_mute;
    GtkScale *in_scale;
    AdwSwitchRow *in_mute;
    gboolean updating;
} AudioWidgets;

static void on_out_vol_changed(GtkRange *range, gpointer user_data) {
    AudioWidgets *aw = (AudioWidgets *)user_data;
    if (aw->updating) return;
    double val = gtk_range_get_value(range) / 100.0;
    char *cmd = g_strdup_printf("wpctl set-volume @DEFAULT_AUDIO_SINK@ %.2f", val);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_out_mute_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec;
    AudioWidgets *aw = (AudioWidgets *)user_data;
    if (aw->updating) return;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("wpctl set-mute @DEFAULT_AUDIO_SINK@ %d", active ? 1 : 0);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_in_vol_changed(GtkRange *range, gpointer user_data) {
    AudioWidgets *aw = (AudioWidgets *)user_data;
    if (aw->updating) return;
    double val = gtk_range_get_value(range) / 100.0;
    char *cmd = g_strdup_printf("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ %.2f", val);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_in_mute_toggled(GObject *object, GParamSpec *pspec, gpointer user_data) {
    (void)pspec;
    AudioWidgets *aw = (AudioWidgets *)user_data;
    if (aw->updating) return;
    gboolean active = adw_switch_row_get_active(ADW_SWITCH_ROW(object));
    char *cmd = g_strdup_printf("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ %d", active ? 1 : 0);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

static void on_test_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn; (void)user_data;
    run_cmd_fire_and_forget("pw-play /usr/share/sounds/freedesktop/stereo/complete.oga");
}

AdwPreferencesPage *create_audio_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Sound & Audio");
    adw_preferences_page_set_icon_name(page, "audio-volume-high-symbolic");
    adw_preferences_page_set_name(page, "audio");

    AudioWidgets *aw = g_new0(AudioWidgets, 1);

    // Playback group
    AdwPreferencesGroup *out_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(out_group, "Playback Output");
    adw_preferences_group_set_description(out_group, "Speakers, headphones, and HDMI audio");
    adw_preferences_page_add(page, out_group);

    AdwActionRow *out_vol_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(out_vol_row), "Master Volume");
    adw_action_row_set_icon_name(out_vol_row, "audio-speakers-symbolic");

    aw->out_scale = GTK_SCALE(gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0, 100, 1));
    gtk_widget_set_size_request(GTK_WIDGET(aw->out_scale), 200, -1);
    gtk_scale_set_draw_value(aw->out_scale, TRUE);
    gtk_scale_set_value_pos(aw->out_scale, GTK_POS_RIGHT);
    g_signal_connect(aw->out_scale, "value-changed", G_CALLBACK(on_out_vol_changed), aw);
    adw_action_row_add_suffix(out_vol_row, GTK_WIDGET(aw->out_scale));
    adw_preferences_group_add(out_group, GTK_WIDGET(out_vol_row));

    aw->out_mute = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(aw->out_mute), "Mute Playback");
    g_signal_connect(aw->out_mute, "notify::active", G_CALLBACK(on_out_mute_toggled), aw);
    adw_preferences_group_add(out_group, GTK_WIDGET(aw->out_mute));

    AdwActionRow *test_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(test_row), "Test Speaker");
    GtkWidget *test_btn = gtk_button_new_with_label("Play Chime");
    gtk_widget_add_css_class(test_btn, "flat");
    g_signal_connect(test_btn, "clicked", G_CALLBACK(on_test_clicked), NULL);
    adw_action_row_add_suffix(test_row, test_btn);
    adw_preferences_group_add(out_group, GTK_WIDGET(test_row));

    // Input group
    AdwPreferencesGroup *in_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(in_group, "Recording Input");
    adw_preferences_group_set_description(in_group, "Microphones and headset inputs");
    adw_preferences_page_add(page, in_group);

    AdwActionRow *in_vol_row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(in_vol_row), "Microphone Volume");
    adw_action_row_set_icon_name(in_vol_row, "audio-input-microphone-symbolic");

    aw->in_scale = GTK_SCALE(gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0, 100, 1));
    gtk_widget_set_size_request(GTK_WIDGET(aw->in_scale), 200, -1);
    gtk_scale_set_draw_value(aw->in_scale, TRUE);
    gtk_scale_set_value_pos(aw->in_scale, GTK_POS_RIGHT);
    g_signal_connect(aw->in_scale, "value-changed", G_CALLBACK(on_in_vol_changed), aw);
    adw_action_row_add_suffix(in_vol_row, GTK_WIDGET(aw->in_scale));
    adw_preferences_group_add(in_group, GTK_WIDGET(in_vol_row));

    aw->in_mute = ADW_SWITCH_ROW(adw_switch_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(aw->in_mute), "Mute Microphone");
    g_signal_connect(aw->in_mute, "notify::active", G_CALLBACK(on_in_mute_toggled), aw);
    adw_preferences_group_add(in_group, GTK_WIDGET(aw->in_mute));

    // Query initial values
    aw->updating = TRUE;
    char *out_info = run_cmd("wpctl get-volume @DEFAULT_AUDIO_SINK@");
    if (out_info) {
        double v = 0.5;
        if (sscanf(out_info, "Volume: %lf", &v) == 1) {
            gtk_range_set_value(GTK_RANGE(aw->out_scale), v * 100.0);
        }
        adw_switch_row_set_active(aw->out_mute, strstr(out_info, "[MUTED]") != NULL);
        g_free(out_info);
    }

    char *in_info = run_cmd("wpctl get-volume @DEFAULT_AUDIO_SOURCE@");
    if (in_info) {
        double v = 0.5;
        if (sscanf(in_info, "Volume: %lf", &v) == 1) {
            gtk_range_set_value(GTK_RANGE(aw->in_scale), v * 100.0);
        }
        adw_switch_row_set_active(aw->in_mute, strstr(in_info, "[MUTED]") != NULL);
        g_free(in_info);
    }
    aw->updating = FALSE;

    return page;
}
