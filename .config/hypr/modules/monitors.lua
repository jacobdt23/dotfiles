------------------
---- MONITORS ----
------------------

-- HDMI-A-1 is primary at 1920x1080@100Hz
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@100",
    position = "0x0",
    scale    = "1",
})

-- DP-2 / DP-1 secondary positioned to the right at 1920x1080@100Hz
hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@100",
    position = "1920x0",
    scale    = "1",
})

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@100",
    position = "1920x0",
    scale    = "1",
})

-- Fallback for any other monitor (eDP-1, Virtual-1, etc.)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
