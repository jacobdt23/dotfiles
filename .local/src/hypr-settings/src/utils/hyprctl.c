#include "hyprctl.h"
#include "command.h"
#include <stdio.h>

void hyprctl_set(const char *option, const char *value) {
    if (!option || !value) return;
    char *cmd = g_strdup_printf("hyprctl keyword %s %s", option, value);
    run_cmd_fire_and_forget(cmd);
    g_free(cmd);
}

void hyprctl_set_int(const char *option, int value) {
    char *val = g_strdup_printf("%d", value);
    hyprctl_set(option, val);
    g_free(val);
}

void hyprctl_set_float(const char *option, double value) {
    char *val = g_strdup_printf("%.2f", value);
    hyprctl_set(option, val);
    g_free(val);
}

char *hyprctl_get(const char *option) {
    if (!option) return NULL;
    char *cmd = g_strdup_printf("hyprctl getoption %s -j", option);
    char *res = run_cmd(cmd);
    g_free(cmd);
    return res;
}
