-- ############################################################################
-- Per-workspace wallpapers
-- ############################################################################

local function apply()
  hl.exec_cmd("wallpaper-per-workspace apply")
end

hl.on("hyprland.start", apply)
hl.on("workspace.active", apply)
hl.on("workspace.move_to_monitor", apply)
hl.on("monitor.added", apply)
hl.on("monitor.removed", apply)
hl.on("monitor.focused", apply)
hl.on("config.reloaded", apply)
