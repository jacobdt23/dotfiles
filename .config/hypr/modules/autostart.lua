---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "dolphin"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- Start Apps
    hl.exec_cmd("terminal")
    hl.exec_cmd("nm-applet")

    -- Background Services
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hyprpm reload -n")

    -- Start Quickshell
    hl.exec_cmd("quickshell")
end)
