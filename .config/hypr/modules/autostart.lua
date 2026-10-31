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
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")

    -- Background Services
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sh ~/.config/hypr/wallpaper_loop.sh")
    hl.exec_cmd("hyprpm reload -n")

    -- Start Jacob's Python/GTK desktop shell (top bar, dock, launcher, notifications)
    hl.exec_cmd("/usr/local/bin/jacob-shell")
end)
