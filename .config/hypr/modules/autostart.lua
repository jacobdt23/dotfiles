---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "thunar"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- Start Apps
    hl.exec_cmd("nm-applet")

    -- Background Services
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sh -c 'sleep 0.5 && (awww restore || awww img ~/Pictures/Wallpapers/default.png)'")
    hl.exec_cmd("hyprpm reload -n")

    -- TokyoNight Theme Settings
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")

    -- Start Jacob's Python/GTK desktop shell (top bar, dock, launcher, notifications)
    hl.exec_cmd("/usr/local/bin/jacob-shell")
end)
