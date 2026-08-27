-- ############################################################################
-- Hyprland configuration (Lua)
--
-- Docs: https://wiki.hypr.land/Configuring/Start/
-- ############################################################################

require("modules.startup") -- env vars + autostart
require("modules.monitors") -- outputs + workspace/monitor binding
require("modules.look-and-feel") -- general, decoration, animations, layouts, misc
require("modules.input") -- input devices + every keybind
require("modules.rules") -- window rules
