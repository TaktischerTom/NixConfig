{ ... }:
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
    QS_CONFIG_PATH = "/home/tom/amnytas/config/rice/quickshell";
    EDITOR = "codium";
    XCURSOR_THEME = "Elysia Cursor";
    XR_RUNTIME_JSON = "$HOME/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
  };

  environment.sessionVariables = {
    YDOTOOL_SOCKET = "/run/user/1000/ydotoold/socket";
    XR_RUNTIME_JSON = "$HOME/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
  };
}
