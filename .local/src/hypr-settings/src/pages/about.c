#include "about.h"
#include "../utils/command.h"
#include <stdio.h>
#include <string.h>
#include <sys/utsname.h>

static void add_spec_row(AdwPreferencesGroup *group, const char *title, const char *value, const char *icon) {
    AdwActionRow *row = ADW_ACTION_ROW(adw_action_row_new());
    adw_preferences_row_set_title(ADW_PREFERENCES_ROW(row), title);
    adw_action_row_set_subtitle(row, value ? value : "Unknown");
    if (icon) adw_action_row_set_icon_name(row, icon);
    adw_preferences_group_add(group, GTK_WIDGET(row));
}

AdwPreferencesPage *create_about_page(void) {
    AdwPreferencesPage *page = ADW_PREFERENCES_PAGE(adw_preferences_page_new());
    adw_preferences_page_set_title(page, "System Info");
    adw_preferences_page_set_icon_name(page, "dialog-information-symbolic");
    adw_preferences_page_set_name(page, "about");

    AdwPreferencesGroup *group = ADW_PREFERENCES_GROUP(adw_preferences_group_new());
    adw_preferences_group_set_title(group, "Hardware & Software Specifications");
    adw_preferences_page_add(page, group);

    // OS
    char *os_out = run_cmd("grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"'");
    add_spec_row(group, "Operating System", os_out ? os_out : "Arch Linux", "distributor-logo-archlinux-symbolic");
    if (os_out) g_free(os_out);

    // Compositor
    char *hypr_out = run_cmd("hyprctl version | grep -E 'Tag:|commit' | head -n1");
    char *comp = g_strdup_printf("Hyprland %s", hypr_out ? hypr_out : "(Wayland)");
    add_spec_row(group, "Wayland Compositor", comp, "preferences-desktop-display-symbolic");
    g_free(comp);
    if (hypr_out) g_free(hypr_out);

    // Kernel
    struct utsname un;
    if (uname(&un) == 0) {
        add_spec_row(group, "Kernel Version", un.release, "applications-system-symbolic");
        add_spec_row(group, "Device Hostname", un.nodename, "computer-symbolic");
    }

    // CPU
    char *cpu_out = run_cmd("grep -m1 'model name' /proc/cpuinfo | cut -d: -f2");
    add_spec_row(group, "Processor (CPU)", cpu_out ? g_strstrip(cpu_out) : "Unknown", "cpu-symbolic");
    if (cpu_out) g_free(cpu_out);

    // RAM
    char *mem_out = run_cmd("grep MemTotal /proc/meminfo | awk '{printf \"%.1f GiB\", $2/1048576}'");
    add_spec_row(group, "Total Memory (RAM)", mem_out ? mem_out : "Unknown", "drive-harddisk-symbolic");
    if (mem_out) g_free(mem_out);

    return page;
}
