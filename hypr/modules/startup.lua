-- ############################################################################
-- Environment variables & autostart
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- ############################################################################

local programs = require("modules.programs")

--------------------------------------------------------------------------------
-- Environment variables
--------------------------------------------------------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

--------------------------------------------------------------------------------
-- Autostart
--------------------------------------------------------------------------------

hl.on("hyprland.start", function()
  -- Shell / desktop environment
  hl.exec_cmd("caelestia-shell")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- fcitx5 is started by its own autostart unit; stop it so it is opt-in via
  -- the SUPER+I toggle in modules/input.lua.
  hl.exec_cmd("systemctl --user stop " .. programs.fcitxService)

  -- Input remapping + colour picker daemon
  hl.exec_cmd("input-remapper-control --command autoload")
  hl.exec_cmd("ie-r")

  -- Applications
  hl.exec_cmd("wanikani-launch")
  hl.exec_cmd("steam -console")
  hl.exec_cmd("me.amankhanna.opendeck")
  hl.exec_cmd("vesktop")
  
  hl.exec_cmd("obs", { workspace = "6" })
end)
