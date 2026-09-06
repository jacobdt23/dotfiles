-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = { top = 5, right = 5, bottom = 5, left = 5 },
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.9, 

        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 3,
            color        = 0x66000000,
        },

        blur = {
            enabled            = true,
            size               = 8,
            passes             = 3,
            vibrancy           = 0.1696,
            new_optimizations = true,
            xray               = true,
        },
    },

    animations = {
        enabled = true,
    },
})
