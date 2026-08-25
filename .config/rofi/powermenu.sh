#!/usr/bin/env bash

# Define the custom choices
options="󰐥 Shutdown\n󰜉 Reboot\n󰈆 Logout\n󰤄 Suspend"

# Launch rofi with your existing theme
chosen=$(echo -e "$options" | rofi -dmenu -i -p "System Session:")

# Execute the target action
case "$chosen" in
    *Shutdown) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Logout) hyprctl dispatch exit ;;
    *Suspend) systemctl suspend ;;
esac
