local M = {}

local direction_monitor = function(direction)
  local mons, activeMon, target = hl.get_monitors(), hl.get_active_monitor() or 1, 1
  table.sort(mons, function(a, b)
    return a.x < b.x
  end)
  for i, mon in ipairs(mons) do
    target = mon.id == activeMon.id and (i - 1 + direction * 1) % #mons + 1 or target
  end
  return mons[target]
end

M.direction_focus = function(direction)
  return function()
    hl.dispatch(hl.dsp.focus({ workspace = direction_monitor(direction).active_workspace }))
  end
end

M.direction_move = function(direction)
  return function()
    hl.dispatch(hl.dsp.window.move({ workspace = direction_monitor(direction).active_workspace }))
  end
end

M.direction_move_workspace = function(direction)
  return function()
    hl.dispatch(hl.dsp.workspace.move({ monitor = direction_monitor(direction) }))
  end
end

return M