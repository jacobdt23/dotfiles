--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name       = "fix-xwayland-drags",
    match      = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name   = "calamares-floating-installer",
    match  = { class = ".*calamares.*" },
    float  = true,
    size   = "920 600",
    center = true,
})

hl.window_rule({
    name   = "timeshift-floating",
    match  = { class = ".*[Tt]imeshift.*" },
    float  = true,
    size   = "900 620",
    center = true,
})

hl.window_rule({
    name   = "pavucontrol-floating",
    match  = { class = ".*pavucontrol.*" },
    float  = true,
    size   = "760 520",
    center = true,
})

hl.window_rule({
    name   = "blueman-floating",
    match  = { class = ".*blueman.*" },
    float  = true,
    size   = "720 480",
    center = true,
})

hl.window_rule({
    name   = "systemsettings-floating",
    match  = { class = ".*systemsettings.*" },
    float  = true,
    size   = "1020 700",
    center = true,
})

hl.window_rule({
    name   = "hyprsettings-floating",
    match  = { class = ".*hypr-?settings.*" },
    float  = true,
    size   = "950 660",
    center = true,
})

hl.window_rule({
    name            = "davinci-resolve-no-follow-mouse",
    match           = { class = "^(resolve)$" },
    no_follow_mouse = true,
})

hl.window_rule({
    name     = "conky-keybinds-right",
    match    = { class = "^(conky-keybinds)$" },
    float    = true,
    pin      = true,
    no_focus = true,
    move     = { "(monitor_w-window_w-22)", "((monitor_h-window_h)/2-18)" },
})

hl.layer_rule({
    match   = { namespace = "^(waybar|conky-keybinds-bg|nwg-dock)$" },
    no_anim = true,
})

hl.layer_rule({
    match = { namespace = "jacob-(topbar|dock|launcher|clipboard|power|calendar|notifications|toast|media|keybinds|welcome|contextmenu|appcontextmenu|taskbarmenu)" },
    blur  = true,
})


