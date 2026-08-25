package.path = debug.getinfo(1, "S").source:match("@(.*/)") .. "?.lua;" .. package.path

require("modules.monitors")
require("modules.binds")
require("modules.autostart")
require("modules.env")
require("modules.decorations")
require("modules.layout")
require("modules.input")
require("modules.windowrules")
