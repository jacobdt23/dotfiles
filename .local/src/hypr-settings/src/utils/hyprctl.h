#ifndef HYPRCTL_H
#define HYPRCTL_H

#include <glib.h>

void hyprctl_set(const char *option, const char *value);
void hyprctl_set_int(const char *option, int value);
void hyprctl_set_float(const char *option, double value);
char *hyprctl_get(const char *option);

#endif // HYPRCTL_H
