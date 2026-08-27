-- ############################################################################
-- Shared definitions
-- ############################################################################

return {
  -- Main modifier ("Windows" key)
  mainMod = "SUPER",

  -- Programs
  terminal = "foot",
  fileManager = "thunar",
  menu = "wofi --show drun",

  -- systemd --user unit for the fcitx5 input method, toggled by SUPER+I and
  -- stopped on startup. Kept here so the name is defined exactly once.
  fcitxService = "app-org.fcitx.Fcitx5@autostart.service",
}
