local mainMod = "SUPER"

-- Core App Binds
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("jacob-shell toggle welcome"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))

-- App Launcher / Menu (Super alone)
hl.bind("SUPER + Super_L", hl.dsp.exec_cmd("jacob-shell toggle launcher"), { release = true })

-- System Management
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("notify-send 'Jacob Shell' 'Active!'"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("sh -c 'hyprctl reload && notify-send \"Hyprland\" \"Reloaded!\"'"))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("kitty -e btop"))

-- Screenshot Utility (grim + slurp + swappy)
hl.bind("Print", hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot area"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot full"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot window"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("/home/jacob/.local/bin/hypr-screenshot area"))

-- Live Environment Installer (active only when live ISO installer exists)
local calamares_fd = io.open("/usr/local/bin/launch-calamares", "r")
if calamares_fd ~= nil then
    calamares_fd:close()
    hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("/usr/local/bin/launch-calamares"))
end

-- jacob-shell Menus
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("jacob-shell toggle keybinds"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("jacob-shell toggle power"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("jacob-shell toggle notifications"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("jacob-shell toggle media"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("jacob-shell toggle clipboard"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("jacob-shell toggle calendar"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("jacob-shell toggle controlcenter"))

-- Window Management
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ monitor = "+1" }))

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Window Interactions
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("mouse:274", hl.dsp.window.drag(), { mouse = true })

-- jacob-shell Volume Controls
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("jacob-shell volume up"), { repeating = true })
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("jacob-shell volume down"), { repeating = true })
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd("jacob-shell volume mute"))
