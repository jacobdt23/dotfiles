#ifndef COMMAND_H
#define COMMAND_H

#include <glib.h>

char *run_cmd(const char *cmd);
void run_cmd_fire_and_forget(const char *cmd);

typedef void (*CmdCallback)(gboolean success, const char *output, gpointer user_data);
void run_cmd_async(const char *cmd, CmdCallback callback, gpointer user_data);

#endif // COMMAND_H
