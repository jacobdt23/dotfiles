---------------------------------------
---- LOOK AND FEEL (Omarchy-esque) ----
---------------------------------------
hl.config({
    general = {
        gaps_in                 = 4,
        gaps_out                = 8,
        border_size             = 2,
        resize_on_border        = true,
        extend_border_grab_area = 8,
        hover_icon_on_border    = true,
        allow_tearing           = false,
        col = {
            active_border   = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
            inactive_border = "rgba(414868aa)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding         = 8,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 14,
            render_power = 3,
            color        = 0x55000000,
        },

        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Omarchy snappy bezier curves & instant workspace switching
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true,  speed = 8,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 4.31, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 3.03, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 3.28, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.19, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.38, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.17, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 2.42, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch",    enabled = false })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.05, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 3.2,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.2,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.43, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.11, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false })
