-- ############################################################################
-- Input & keybinds
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/
-- ############################################################################

local programs = require("modules.programs")

local mod = programs.mainMod
local modShift = mod .. " + SHIFT"
local modCtrl = "CTRL + " .. mod

--------------------------------------------------------------------------------
-- Input devices
--------------------------------------------------------------------------------

hl.config({
  input = {
    kb_layout = "eu",
    kb_variant = "",
    kb_model = "",
    kb_options = "srvrkeys:none, caps:escape, lv3:switch",
    kb_rules = "",

    follow_mouse = 1,
    sensitivity = 0, -- -1.0 to 1.0, 0 means no modification

    touchpad = {
      natural_scroll = false,
    },
  },
})

-- Per-device config
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

--------------------------------------------------------------------------------
-- Applications
--------------------------------------------------------------------------------

hl.bind(mod .. " + K", hl.dsp.exec_cmd(programs.terminal), { description = "Alternate terminal" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd(programs.fileManager), { description = "File manager" })
hl.bind(mod .. " + R", hl.dsp.exec_cmd(programs.menu), { description = "App launcher" })
hl.bind(mod .. " + F12", hl.dsp.exec_cmd("$(tofi-run)"), { description = "tofi launcher" })

-- Caelestia shell launcher
hl.bind(mod .. " + SPACE", hl.dsp.global("caelestia:launcher"), { description = "Caelestia launcher" })

-- Firefox in a private profile
hl.bind(mod .. " + P", hl.dsp.exec_cmd("vpn-run firefox -P private"), { description = "Firefox (VPN)" })

--------------------------------------------------------------------------------
-- Window management
--------------------------------------------------------------------------------

hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mod .. " + F", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })

-- Move focus
for _, direction in ipairs({ "left", "right", "up", "down" }) do
  hl.bind(mod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Kill the window under the cursor (interactive picker)
hl.bind(mod .. " + BACKSPACE", hl.dsp.exec_cmd("hyprctl kill"), { description = "Kill picker" })

--------------------------------------------------------------------------------
-- Workspaces
--------------------------------------------------------------------------------
local workspaceKeys = {
  { key = "1", workspace = 1 },
  { key = "2", workspace = 2 },
  { key = "3", workspace = 3 },
  { key = "F2", workspace = 4 },
  { key = "F3", workspace = 5 },
  { key = "F4", workspace = 6 },
  { key = "4", workspace = 7 },
  { key = "5", workspace = 8 },
  { key = "6", workspace = 9 },
  { key = "0", workspace = 10 },
}

for _, entry in ipairs(workspaceKeys) do
  -- Switch to workspace
  hl.bind(mod .. " + " .. entry.key, hl.dsp.focus({ workspace = entry.workspace }))
  -- Move active window to workspace
  hl.bind(modShift .. " + " .. entry.key, hl.dsp.window.move({ workspace = entry.workspace }))
end

-- Special workspaces
hl.bind(mod .. " + Z", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle scratchpad" })
hl.bind(modShift .. " + Z", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + W", hl.dsp.workspace.toggle_special("wanikani"), { description = "Toggle WaniKani" })
hl.bind(modShift .. " + W", hl.dsp.window.move({ workspace = "special:wanikani" }))

-- Switch workspace direction
hl.bind(mod .. " + A", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + D", hl.dsp.focus({ monitor = "r" }))

--------------------------------------------------------------------------------
-- Layout messages
--------------------------------------------------------------------------------

hl.bind(mod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mod .. " + comma", hl.dsp.layout("move -col"))

-- Same, with the scroll wheel
hl.bind(mod .. " + mouse_down", hl.dsp.layout("move +col"))
hl.bind(mod .. " + mouse_up", hl.dsp.layout("move -col"))

--------------------------------------------------------------------------------
-- Media & hardware keys
--------------------------------------------------------------------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- Stop the lone SUPER press from triggering anything.
hl.bind("SUPER_L", hl.dsp.no_op(), { release = true })

--------------------------------------------------------------------------------
-- Screenshots & recording
--------------------------------------------------------------------------------

local screenshotDir = "~/Pictures"
local videoDir = "~/Videos"

-- Region -> swappy -> clipboard + file
hl.bind(
  modShift .. " + S",
  hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f - -o - | wl-copy; wl-paste > ' .. screenshotDir .. "/screenshot.png"),
  { description = "Screenshot region" }
)
hl.bind(
  "CTRL + " .. modShift .. " + S",
  hl.dsp.exec_cmd("grimblast save area - | swappy -f - -o - | wl-copy; wl-paste > " .. screenshotDir .. "/screenshot.png"),
  { description = "Screenshot area (grimblast)" }
)
hl.bind(
  modCtrl .. " + S",
  hl.dsp.exec_cmd("grimblast --freeze save output - | swappy -f - -o - | wl-copy; wl-paste > " .. screenshotDir .. "/Screenshot.png"),
  { description = "Screenshot output (frozen)" }
)

-- Recording: region / output, and SIGINT to stop
hl.bind(modShift .. " + X", hl.dsp.exec_cmd("wf-recorder -y -f " .. videoDir .. '/wf-recording.mp4 -g "$(slurp)"'), { description = "Record region" })
hl.bind(modCtrl .. " + X", hl.dsp.exec_cmd("wf-recorder -y -f " .. videoDir .. '/wf-recording.mp4 -g "$(slurp -o)"'), { description = "Record output" })
hl.bind(mod .. " + X", hl.dsp.exec_cmd("pkill --signal SIGINT wf-recorder"), { description = "Stop recording" })

--------------------------------------------------------------------------------
-- Colour picker (ie-r) & clipboard
--------------------------------------------------------------------------------

hl.bind(modShift .. " + C", hl.dsp.exec_cmd("pkill -SIGUSR1 ie-r"), { description = "Pick colour" })
hl.bind(modShift .. " + H", hl.dsp.exec_cmd("pkill -SIGUSR2 ie-r"), { description = "Colour history" })
hl.bind("CTRL + F10", hl.dsp.exec_cmd("clipper"), { description = "Clipboard manager" })

--------------------------------------------------------------------------------
-- Passthrough binds
--------------------------------------------------------------------------------

-- OBS start/stop recording hotkey
hl.bind("CTRL + F9", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }), { description = "OBS hotkey" })

-- Discord (vesktop) push-to-mute
hl.bind("CTRL + SHIFT + M", hl.dsp.pass({ window = "class:^(vesktop)$" }), { description = "Discord mute" })

--------------------------------------------------------------------------------
-- Input method toggle (fcitx5)
--------------------------------------------------------------------------------

-- Toggle the fcitx5 user unit on/off.
local fcitxToggle = table.concat({
  "if systemctl --user is-active --quiet " .. programs.fcitxService .. "; then",
  "systemctl --user stop " .. programs.fcitxService .. ";",
  "else",
  "systemctl --user start " .. programs.fcitxService .. ";",
  "fi",
}, " ")

hl.bind(mod .. " + I", hl.dsp.exec_cmd(fcitxToggle), { description = "Toggle fcitx5" })

--------------------------------------------------------------------------------
-- Waydroid
--------------------------------------------------------------------------------

hl.bind(mod .. " + H", hl.dsp.exec_cmd("waydroid show-full-ui"), { description = "Waydroid UI" })
hl.bind(mod .. " + L", hl.dsp.exec_cmd("waydroid session start"), { description = "Waydroid start" })
hl.bind(modShift .. " + L", hl.dsp.exec_cmd("waydroid session stop"), { description = "Waydroid stop" })

--------------------------------------------------------------------------------
-- Misc
--------------------------------------------------------------------------------

-- Autoclicker toggle
hl.bind("ALT + SHIFT + F11", hl.dsp.exec_cmd("killall autoclicker || (sleep 1 && autoclicker 0.065)"), { description = "Toggle autoclicker" })
