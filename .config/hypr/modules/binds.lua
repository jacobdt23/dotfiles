local mainMod = "SUPER"

-- Core App Binds (Omarchy-aligned)
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + W",      hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + D",      hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("kitty -e btop"))

-- App Launcher & Menus
hl.bind("SUPER + Super_L",     hl.dsp.exec_cmd("rofi -show drun"), { release = true })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + D",     hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("F24",                 hl.dsp.exec_cmd("rofi -show drun"))

-- System Management
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("sh -c 'hyprctl reload && pkill waybar; waybar & notify-send \"Hyprland\" \"Reloaded!\"'"))
hl.bind(mainMod .. " + CTRL + L",  hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + K",         hl.dsp.exec_cmd("/home/jacob/.local/bin/toggle-conky-background"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("/home/jacob/.local/bin/toggle-conky-keybinds"))
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd("sh -c 'choice=$(printf \"󰌾  Lock\\n󰤄  Suspend\\n󰜉  Reboot\\n󰐥  Shutdown\\n󰍃  Log out\" | rofi -dmenu -i -p System); case \"$choice\" in *Lock*) hyprlock;; *Suspend*) systemctl suspend;; *Reboot*) systemctl reboot;; *Shutdown*) systemctl poweroff;; *Log*) hyprctl dispatch exit;; esac'"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-clipboard"))

-- Screenshot Utility (grim + slurp + swappy / flameshot)
hl.bind("Print",                   hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot area"))
hl.bind("SHIFT + Print",           hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot full"))
hl.bind(mainMod .. " + Print",     hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot window"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot area"))

-- Live Environment Installer (active only when live ISO installer exists)
local calamares_fd = io.open("/usr/local/bin/launch-calamares", "r")
if calamares_fd ~= nil then
    calamares_fd:close()
    hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("/usr/local/bin/launch-calamares"))
end

-- Window Management
hl.bind(mainMod .. " + V",   hl.dsp.window.float())
hl.bind(mainMod .. " + O",   hl.dsp.exec_cmd("sh -c 'hyprctl dispatch togglefloating active && hyprctl dispatch pin active'"))
hl.bind(mainMod .. " + F",   hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P",   hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",   hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ monitor = "+1" }))

-- Move focus & swap windows
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",       hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Window Interactions
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("mouse:274",               hl.dsp.window.drag(),   { mouse = true })

-- Volume Controls
hl.bind(mainMod .. " + equal",     hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind(mainMod .. " + minus",     hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
