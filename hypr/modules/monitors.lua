-- ############################################################################
-- Monitors & workspace placement
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- ############################################################################

--------------------------------------------------------------------------------
-- Outputs
--------------------------------------------------------------------------------

hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = "auto" })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "-1920x0", scale = "auto" })
hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "760x1440", scale = "auto" })

-- Catch-all
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

--------------------------------------------------------------------------------
-- Workspace -> monitor binding
--------------------------------------------------------------------------------

local workspacesByMonitor = {
  ["DP-1"] = { 1, 2, 3 },
  ["HDMI-A-2"] = { 4, 5, 6, 10 },
  ["HDMI-A-1"] = { 7, 8, 9 },
}

for monitor, workspaces in pairs(workspacesByMonitor) do
  for _, workspace in ipairs(workspaces) do
    hl.workspace_rule({ workspace = tostring(workspace), monitor = monitor })
  end
end
