#!/bin/bash
# =============================================================================
# HyprFrost Qtile Autostart Script
# =============================================================================

# 1. Sync D-Bus and systemd user session environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE

# 2. Keyring & Network Applet
gnome-keyring-daemon --start --components=secrets &
nm-applet &
if [ -n "$WAYLAND_DISPLAY" ]; then
    wl-paste --type text --watch cliphist store &
fi

# 3. Allow compositor event loop to settle
sleep 0.5

# 4. Clean up any stale sockets and launch Jacob Shell
pkill -9 -f jacob-shell 2>/dev/null || true
rm -f "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/jacob-shell.sock"

mkdir -p "$HOME/.local/share/qtile"
jacob_bin="$HOME/.local/bin/jacob-shell"
if [ ! -x "$jacob_bin" ]; then
    jacob_bin="/usr/local/bin/jacob-shell"
fi

exec "$jacob_bin" --replace >> "$HOME/.local/share/qtile/jacob-shell.log" 2>&1
