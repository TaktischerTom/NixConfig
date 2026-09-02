-- ############################################################################
-- Window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- ############################################################################

--------------------------------------------------------------------------------
-- Global fixes
--------------------------------------------------------------------------------

-- Ignore maximize requests from apps.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland.
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

--------------------------------------------------------------------------------
-- Application placement
--------------------------------------------------------------------------------

hl.window_rule({
  name = "steam-to-ws1",
  match = { class = "steam" },
  workspace = "1",
})

hl.window_rule({
  name = "games-to-ws3",
  match = { class = "steam_app_.*" },
  workspace = "3",
})

hl.window_rule({
  name = "vesktop-to-ws5",
  match = { class = "vesktop.*" },
  workspace = "5",
})

hl.window_rule({
  name = "video-trimmer-to-ws5",
  match = { class = "^(org.gnome.gitlab.YaLTeR.VideoTrimmer)$" },
  workspace = "5",
})

hl.window_rule({
  name = "opendeck-to-ws6",
  match = { class = "opendeck" },
  workspace = "6",
})

hl.window_rule({
  name = "krita-to-ws10",
  match = { class = "krita" },
  workspace = "10",
})

--------------------------------------------------------------------------------
-- Floating windows
--------------------------------------------------------------------------------

hl.window_rule({
  name = "keepassxc-float",
  match = { class = "org.keepassxc.KeePassXC" },
  float = true,
  size = { 500, 500 },
})

--------------------------------------------------------------------------------
-- Force fullscreen
--------------------------------------------------------------------------------

local fullscreenClasses = {
  "waydroid.com.supercell.clashofclans",
  "waydroid.game.qualiarts.hololive.dreams.com",
  "genshinimpact.exe",
  "steam_app_3513350",
  "steam_app_418530",
  "^Waydroid$",
}

for _, class in ipairs(fullscreenClasses) do
  hl.window_rule({
    match = { class = class },
    fullscreen = true,
  })
end

--------------------------------------------------------------------------------
-- Game tagging
--------------------------------------------------------------------------------

local gameClasses = {
  "^(steam_app.*)$",
  "^(waywall.*)$",
  "^(gamescope)$",
  "^(moe\\.launcher.*)$",
  "^(starrail\\.exe)$",
  "^(ffxiv_dx11\\.exe)$",
  "^(genshinimpact\\.exe)$",
  "codium-url-handler",
}

for _, class in ipairs(gameClasses) do
  hl.window_rule({
    match = { class = class },
    tag = "+game",
  })
end

hl.window_rule({
  name = "aagl-launcher",
  match = { class = "^(moe\\.launcher\\.an-anime-game-launcher)$" },
  tag = "+game",
  float = true,
})

-- Some games don't like not being rendered.
hl.window_rule({
  name = "games-render-unfocused",
  match = { tag = "game" },
  render_unfocused = true,
})
