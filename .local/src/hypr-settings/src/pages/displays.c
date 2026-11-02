#include "displays.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>

typedef struct {
    char *mon_name;
    GtkSpinButton *scale_spin;
} MonScaleData;

static void on_apply_scale_clicked(GtkButton *btn, gpointer user_data) {
    (void)btn;
    MonScaleData *msd = (MonScaleData *)user_data;
    double scale = gtk_spin_button_get_value(msd->scale_spin);
    char *cmd = g_strdup_printf("hyprctl keyword monitor \"%s,preferred,auto,%.2f\"", msd->mon_name, scale);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

AdwPreferencesPage *create_displays_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "Displays");
    adw_preferences_page_set_icon_name(page, "video-display-symbolic");
    adw_preferences_page_set_name(page, "displays");

    AdwPreferencesGroup *mon_group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(mon_group, "Connected Displays");
    adw_preferences_group_set_description(mon_group, "Configure resolution and Wayland display scaling");
    adw_preferences_page_add(page, mon_group);

    char *mon_out = run_cmd("hyprctl monitors");
    if (!mon_out || strlen(mon_out) == 0) {
        AdwActionRow *no_row = ADW_ACTION_ROW(adw_action_row_new());
        adw_preferences_row_set_title(ADW_PREFERENCES_ROW(no_row), "No active displays detected");
        adw_preferences_group_add(mon_group, GTK_WIDGET(no_row));
        if (mon_out) g_free(mon_out);
        return page;
    }

    char **lines = g_strsplit(mon_out, "\n", -1);
    char cur_name[64] = {0};
    char cur_model[128] = {0};
    char cur_res[64] = {0};
    double cur_scale = 1.0;

    for (int i = 0; lines[i] != NULL; i++) {
        char *line = g_strstrip(lines[i]);
        if (g_str_has_prefix(line, "Monitor ")) {
            sscanf(line, "Monitor %63s", cur_name);
        } else if (g_str_has_prefix(line, "model: ")) {
            g_strlcpy(cur_model, line + 7, sizeof(cur_model));
        } else if (strstr(line, "@") && strstr(line, "Hz at")) {
            g_strlcpy(cur_res, line, sizeof(cur_res));
        } else if (g_str_has_prefix(line, "scale: ")) {
            sscanf(line, "scale: %lf", &cur_scale);

            // Add monitor card
            AdwExpanderRow *exp = ADW_EXPANDER_ROW(adw_expander_row_new());
            char *title = g_strdup_printf("%s (%s)", cur_model[0] ? cur_model : "Display", cur_name);
            adw_preferences_row_set_title(ADW_PREFERENCES_ROW(exp), title);
            g_free(title);

            char *sub = g_strdup_printf("%s • Scale: %.2fx", cur_res, cur_scale);
            adw_action_row_set_subtitle(ADW_ACTION_ROW(exp), sub);
            g_free(sub);
            adw_action_row_set_icon_name(ADW_ACTION_ROW(exp), "video-display-symbolic");
            adw_expander_row_set_expanded(exp, TRUE);

            AdwActionRow *scale_row = ADW_ACTION_ROW(adw_action_row_new());
            adw_preferences_row_set_title(ADW_PREFERENCES_ROW(scale_row), "Display Scaling Factor");

            MonScaleData *msd = g_new0(MonScaleData, 1);
            msd->mon_name = g_strdup(cur_name);
            msd->scale_spin = GTK_SPIN_BUTTON(gtk_spin_button_new_with_range(1.0, 3.0, 0.25));
            gtk_spin_button_set_digits(msd->scale_spin, 2);
            gtk_spin_button_set_value(msd->scale_spin, cur_scale);

            GtkWidget *apply_btn = gtk_button_new_with_label("Apply");
            gtk_widget_add_css_class(apply_btn, "suggested-action");
            g_signal_connect_data(apply_btn, "clicked", G_CALLBACK(on_apply_scale_clicked),
                                  msd, (GClosureNotify)g_free, 0);

            GtkWidget *box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6);
            gtk_box_append(GTK_BOX(box), GTK_WIDGET(msd->scale_spin));
            gtk_box_append(GTK_BOX(box), apply_btn);
            adw_action_row_add_suffix(scale_row, box);

            adw_expander_row_add_row(exp, GTK_WIDGET(scale_row));
            adw_preferences_group_add(mon_group, GTK_WIDGET(exp));

            cur_model[0] = 0;
            cur_res[0] = 0;
        }
    }
    g_strfreev(lines);
    g_free(mon_out);

    return page;
}
