#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Ensure swww daemon is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Rotate wallpapers indefinitely every 10 minutes
while true; do
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | \
        shuf -n 1 | \
        xargs -I {} swww img "{}" --transition-type grow --transition-duration 2
    
    sleep 600
done
