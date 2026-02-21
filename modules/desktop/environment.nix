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
  };
}
