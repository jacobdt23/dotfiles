#!/bin/bash
# =============================================================================
# HyprFrost Qtile Autostart Script
# =============================================================================

# Ensure only one instance runs
exec 200>/tmp/qtile-autostart.lock
flock -n 200 || exit 0

# 1. Sync D-Bus and systemd user session environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null || true
systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null || true
export _JAVA_AWT_WM_NONREPARENTING=1

# 2. Display Layout, Anti-Tearing & Compositor (X11)
if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$DISPLAY" ]; then
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --primary --output DP-3 --mode 1920x1080 --pos 1920x0 2>/dev/null || true
    nvidia-settings --assign CurrentMetaMode="HDMI-0: 1920x1080 +0+0 {ForceFullCompositionPipeline=On}, DP-3: 1920x1080 +1920+0 {ForceFullCompositionPipeline=On}" 2>/dev/null || true
    if command -v picom >/dev/null 2>&1; then
        pgrep -x picom >/dev/null || picom -b &
    fi
fi

# 3. Keyring, Notifications & Network Applet
pgrep -x gnome-keyring-d >/dev/null || gnome-keyring-daemon --start --components=secrets &
pgrep -x dunst >/dev/null || dunst &
pgrep -x nm-applet >/dev/null || nm-applet &

# 4. Wayland Clipboard History
if [ -n "$WAYLAND_DISPLAY" ]; then
    pgrep -x cliphist >/dev/null || wl-paste --type text --watch cliphist store &
fi
