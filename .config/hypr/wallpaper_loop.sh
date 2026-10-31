#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"

# Seed default 1080p wallpaper if directory is empty
if [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
    if [ -f "$HOME/.config/hypr/default_wallpaper.png" ]; then
        cp "$HOME/.config/hypr/default_wallpaper.png" "$WALLPAPER_DIR/default.png"
    elif [ -f "$HOME/.config/hypr/default_wallpaper.png" ]; then
        cp "$HOME/.config/hypr/default_wallpaper.png" "$WALLPAPER_DIR/default.png"
    elif [ -f "/usr/share/pixmaps/jacob-arch-logo.png" ]; then
        cp "/usr/share/pixmaps/jacob-arch-logo.png" "$WALLPAPER_DIR/default.png"
    fi
fi

# Detect whether awww or swww is installed
if command -v awww >/dev/null 2>&1; then
    WP_DAEMON="awww-daemon"
    WP_CLIENT="awww"
elif command -v swww >/dev/null 2>&1; then
    WP_DAEMON="swww-daemon"
    WP_CLIENT="swww"
else
    exit 0
fi

# Ensure wallpaper daemon is running
if ! pgrep -x "$WP_DAEMON" >/dev/null 2>&1; then
    "$WP_DAEMON" &
    sleep 1
fi

# Rotate wallpapers indefinitely every 10 minutes
while true; do
    WALLPAPER="$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null | shuf -n 1)"
    if [ -n "$WALLPAPER" ]; then
        "$WP_CLIENT" img "$WALLPAPER" --transition-type grow --transition-duration 2
    fi
    sleep 600
done
