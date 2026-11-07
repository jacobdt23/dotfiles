#!/bin/bash
# =============================================================================
# HyprFrost Qtile Autostart Script
# =============================================================================

# Ensure only one instance runs at a time
exec 200>/tmp/qtile-autostart.lock
flock -n 200 || exit 0

# 1. Sync D-Bus and systemd user session environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null || true
systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null || true

# 2. Keyring, Applet & Clipboard
pgrep -x gnome-keyring-d >/dev/null || gnome-keyring-daemon --start --components=secrets &
pgrep -x nm-applet >/dev/null || nm-applet &
if [ -n "$WAYLAND_DISPLAY" ]; then
    pgrep -x cliphist >/dev/null || wl-paste --type text --watch cliphist store &
fi

# 3. Clean stale socket if daemon is not actually listening
sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/jacob-shell.sock"
if [ -e "$sock" ]; then
    if ! python3 -c "import socket; s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM); s.settimeout(0.2); s.connect('$sock'); s.close()" 2>/dev/null; then
        rm -f "$sock"
    fi
fi

# 4. Launch Jacob Shell if not already active
mkdir -p "$HOME/.local/share/qtile"
jacob_bin="$HOME/.local/bin/jacob-shell"
if [ ! -x "$jacob_bin" ]; then
    jacob_bin="/usr/local/bin/jacob-shell"
fi

if ! pgrep -f "jacob-shell" >/dev/null || [ ! -e "$sock" ]; then
    nohup "$jacob_bin" >> "$HOME/.local/share/qtile/jacob-shell.log" 2>&1 &
fi
