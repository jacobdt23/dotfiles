-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = { top = 8, right = 10, bottom = 8, left = 10 },
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(7aa2f7ee)", "rgba(bb9af7ee)"}, angle = 45 },
            inactive_border = "rgba(3b4261aa)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding         = 12,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.94,

        shadow = {
            enabled      = true,
            range        = 16,
            render_power = 3,
            color        = 0x880f0f17,
        },

        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            vibrancy          = 0.18,
            new_optimizations = true,
            xray              = false,
        },
    },

    animations = {
        enabled = true,
    },
})
