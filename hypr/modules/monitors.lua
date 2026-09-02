-- ############################################################################
-- Monitors & workspace placement
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- ############################################################################

--------------------------------------------------------------------------------
-- Outputs
--------------------------------------------------------------------------------

hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = "1" })
hl.monitor({ output = "DP-2", mode = "preferred", position = "-1920x0", scale = "1" })
hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "760x1440", scale = "1" })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "-3840x0", scale = "1" })

-- Catch-all
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })


--------------------------------------------------------------------------------
-- Tablet Binding
--------------------------------------------------------------------------------

hl.device({
  name = "wacom-cintiq-16-pen",
  output = "HDMI-A-1"
})

hl.device({
  name = "silicon-integrated-system-co.-sis-hid-touch-controller",
  output = "HDMI-A-2"
})

--------------------------------------------------------------------------------
-- Workspace -> monitor binding
--------------------------------------------------------------------------------

local workspacesByMonitor = {
  ["DP-1"] = { 1, 2, 3 },
  ["DP-2"] = { 7, 8, 9 },
  ["HDMI-A-2"] = { 4, 5, 6 },
  ["HDMI-A-1"] = { 10 },
}

for monitor, workspaces in pairs(workspacesByMonitor) do
  for _, workspace in ipairs(workspaces) do
    hl.workspace_rule({ workspace = tostring(workspace), monitor = monitor })
  end
end
