#include "command.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *run_cmd(const char *cmd) {
    if (!cmd) return NULL;
    char *output = NULL;
    GError *error = NULL;
    int exit_status = 0;

    if (g_spawn_command_line_sync(cmd, &output, NULL, &exit_status, &error)) {
        if (exit_status == 0 && output) {
            g_strstrip(output);
            return output;
        }
        g_free(output);
    }
    if (error) {
        g_error_free(error);
    }
    return NULL;
}

void run_cmd_fire_and_forget(const char *cmd) {
    if (!cmd) return;
    GError *error = NULL;
    g_spawn_command_line_async(cmd, &error);
    if (error) {
        g_error_free(error);
    }
}

typedef struct {
    char *cmd;
    CmdCallback callback;
    gpointer user_data;
    gboolean success;
    char *output;
} AsyncData;

static gboolean dispatch_callback(gpointer data) {
    AsyncData *ad = (AsyncData *)data;
    if (ad->callback) {
        ad->callback(ad->success, ad->output ? ad->output : "", ad->user_data);
    }
    g_free(ad->cmd);
    g_free(ad->output);
    g_free(ad);
    return G_SOURCE_REMOVE;
}

static gpointer async_worker(gpointer data) {
    AsyncData *ad = (AsyncData *)data;
    ad->output = run_cmd(ad->cmd);
    ad->success = (ad->output != NULL);
    g_idle_add(dispatch_callback, ad);
    return NULL;
}

void run_cmd_async(const char *cmd, CmdCallback callback, gpointer user_data) {
    if (!cmd) return;
    AsyncData *ad = g_new0(AsyncData, 1);
    ad->cmd = g_strdup(cmd);
    ad->callback = callback;
    ad->user_data = user_data;

    GThread *thread = g_thread_new("cmd-worker", async_worker, ad);
    g_thread_unref(thread);
}
