{ pkgs, ... }:
{
  services.xserver = {
    exportConfiguration = true;
    xkb = {
      layout = "eu";
      variant = "";
      options = "caps:escape,lv3:switch";
    };
  };

  environment.variables = {
    EDITOR = "codium";
    XCURSOR_THEME = "Elysia Cursor";
    XR_RUNTIME_JSON = "$HOME/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
  };

  environment.sessionVariables = {
    YDOTOOL_SOCKET = "/run/user/1000/ydotoold/socket";
    XR_RUNTIME_JSON = "$HOME/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Waydroid Multi-touch Device Fix]
    MatchName=silicon-integrated-system-co.-sis-hid-touch-controller
    ModelTypeTouchscreen=1
    AttrEventHubDevices=touchscreen
  '';

  environment.etc."/hyprlandstubs".source = "${pkgs.hyprland}/share/hypr/stubs";
}
