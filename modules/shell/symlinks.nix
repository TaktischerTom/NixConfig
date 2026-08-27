{
  lib,
  config,
  ...
}: {
  options = {
    links = lib.mkOption {
      default = [];
      type = lib.types.listOf (lib.types.listOf lib.types.str);
    };
  };
  config = {
    system.activationScripts.amnytas-link.text =
      (builtins.concatStringsSep "\n"
        (map (link: "ln -sfn \"/home/${config.mainUser}/${builtins.elemAt link 0}\" \"/home/${config.mainUser}/${builtins.elemAt link 1}\"")
          config.links))
      + "\n echo 'finished updating custom links \\o/'";

    links = [
      ["SystemConfig/hypr/hyprland.lua" ".config/hypr/hyprland.lua"]
      ["SystemConfig/hypr/modules" ".config/hypr/modules"]
      ["SystemConfig/hypr/hyprland.conf" ".config/hypr/hyprland.conf"]
      ["SystemConfig/hypr/xdph.conf" ".config/hypr/xdph.conf"]
      ["SystemConfig/caelestia" ".config/caelestia"]
    ];
  };
}
