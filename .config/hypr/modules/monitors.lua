------------------
---- MONITORS ----
------------------

-- HDMI-A-1 is primary at 1920x1080
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})

-- DP-1 is secondary positioned to the right (1920 pixels offset)
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@60",
    position = "1920x0",
    scale    = "1",
})

-- Map Workspaces 1-5 to the HDMI monitor
for i = 1, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-1"
    })
end

-- Map Workspaces 6-10 to the DP monitor
for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-1"
    })
end
