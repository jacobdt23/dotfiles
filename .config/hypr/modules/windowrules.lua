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
    name         = "looking-glass-behavior",
    match        = { class = "looking-glass-client" },
    idle_inhibit = "always",
})

hl.layer_rule({
    match   = { namespace = "nwg-dock" },
    no_anim = true,
})
