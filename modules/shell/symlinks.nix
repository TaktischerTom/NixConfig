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
        (map (link: "ln -sf \"/home/${config.mainUser}/${builtins.elemAt link 0}\" \"/home/${config.mainUser}/${builtins.elemAt link 1}\"")
          config.links))
      + "\n echo 'finished updating custom links \\o/'";

    links = [
      ["SystemConfig/hypr/hyprland.conf" ".config/hypr/hyprland.conf"]
      ["SystemConfig/hypr/xdph.conf" ".config/hypr/xdph.conf"]
    ];
  };
}
