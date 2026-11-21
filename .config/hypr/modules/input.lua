----------------
---- INPUT ----
----------------

hl.config({
    input = {
        kb_layout         = "us",
        kb_variant        = "",
        kb_model          = "",
        kb_options        = "",
        kb_rules          = "",
        follow_mouse      = 1,
        sensitivity       = 0,
        repeat_rate       = 40,
        repeat_delay      = 250,
        numlock_by_default = true,

        touchpad = {
            natural_scroll       = false,
            clickfinger_behavior = true,
            scroll_factor        = 0.4,
        },
    },

    -- Software cursor avoids NVIDIA/RTX 5070 KMS cursor-plane desyncs
    cursor = {
        no_hardware_cursors      = true,
        hide_on_key_press        = true,
        warp_on_change_workspace = 1,
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
