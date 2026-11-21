---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "thunar"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- Background Services
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sh -c 'sleep 0.5 && (awww restore || awww img ~/Pictures/Wallpapers/default.png)'")
    hl.exec_cmd("hyprpm reload -n")

    -- Tokyo Night + Colloid-Dark Theme Settings
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Dark'")

    -- Omarchy-esque Top Bar, Notifications & Solid Right-Pinned Keybinds Layer
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("/home/jacob/.local/bin/toggle-conky-background --start")
end)
