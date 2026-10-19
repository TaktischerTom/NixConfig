{ config, lib, pkgs, ... }:
let
  cfg = config.desktop.wallpapers;

  quote = value: lib.escapeShellArg (toString value);
  
  pin = pkgs.copyPathToStore;

  # Sourced by scripts/wallpaper-per-workspace.sh.
  wallpaperConfig = pkgs.writeText "wallpaper-per-workspace.bash" ''
    declare -A WALLPAPERS_MAP=(
    ${lib.concatLines (lib.mapAttrsToList (key: value: "  [${quote key}]=${quote (pin value)}") cfg.perWorkspace)}
    )
    WALLPAPERS_DEFAULT=${quote (if cfg.default == null then "" else pin cfg.default)}
    WALLPAPERS_RESIZE=${quote cfg.resize}
    declare -A WALLPAPERS_TRANSITION=(
      [type]=wipe
      [duration]=0.4
      [fps]=${quote cfg.transition.fps}
      [step]=${quote cfg.transition.step}
      [bezier]=${quote cfg.transition.bezier}
    )
    WALLPAPERS_SYNC_CAELESTIA=${if cfg.syncCaelestia then "1" else "0"}
    WALLPAPERS_CAELESTIA_STATE=${quote "${config.users.users.${config.mainUser}.home}/.local/state/caelestia/wallpaper"}
  '';

  package = pkgs.writeShellScriptBin "wallpaper-per-workspace" ''
    export PATH="${
      lib.makeBinPath [
        pkgs.awww
        pkgs.coreutils
        pkgs.gawk
        pkgs.gnused
        pkgs.hyprland
        pkgs.jq
      ]
    }''${PATH:+:$PATH}"
    export WALLPAPERS_CONFIG=${wallpaperConfig}
    ${builtins.readFile ../../scripts/wallpaper-per-workspace.sh}
  '';
in
{
  options.desktop.wallpapers = {
    perWorkspace = lib.mkOption {
      default = {};
      description = ''
        Wallpapers per monitor and workspace, keyed by "<monitor>:<workspace>"
        using the names and ids from `hyprctl monitors`. A "<monitor>:*" key
        sets the wallpaper for every workspace on that monitor; `default`
        covers everything else.

        `wallpaper-per-workspace status` prints the resolved mapping and
        `wallpaper-per-workspace resolve <monitor> <workspace>` the image for a
        single pair.
      '';
      example = lib.literalExpression ''
        {
          "DP-1:1" = ../../assets/wallpaper/one.png;
          "DP-2:*" = ../../assets/wallpaper/other.png;
        }
      '';
      type = lib.types.attrsOf lib.types.path;
    };

    default = lib.mkOption {
      default = null;
      description = "Wallpaper for monitor/workspace pairs that have no entry in `perWorkspace`.";
      type = lib.types.nullOr lib.types.path;
    };

    resize = lib.mkOption {
      default = "crop";
      description = "How awww fits an image to the output.";
      type = lib.types.enum [ "no" "crop" "fit" "stretch" ];
    };

    transition = {
      type = lib.mkOption {
        default = "fade";
        description = "awww transition used when a workspace changes.";
        type = lib.types.enum [
          "none"
          "simple"
          "fade"
          "left"
          "right"
          "top"
          "bottom"
          "wipe"
          "wave"
          "grow"
          "center"
          "any"
          "outer"
          "random"
        ];
      };

      duration = lib.mkOption {
        default = "0.8";
        description = "Transition length in seconds.";
        type = lib.types.str;
      };

      fps = lib.mkOption {
        default = "60";
        description = "Transition frame rate.";
        type = lib.types.str;
      };

      step = lib.mkOption {
        default = "90";
        description = "How fast the transition approaches the new image.";
        type = lib.types.str;
      };

      bezier = lib.mkOption {
        default = ".54,0,.34,.99";
        description = "Bezier curve used by the 'fade' transition.";
        type = lib.types.str;
      };
    };

    syncCaelestia = lib.mkOption {
      default = true;
      description = ''
        Keep Caelestia's wallpaper state ($XDG_STATE_HOME/caelestia/wallpaper)
        pointing at the focused monitor's wallpaper so the lock screen
        (lock.useWallpaper) shows the workspace you locked from. Caelestia's
        colour scheme is deliberately left alone.
      '';
      type = lib.types.bool;
    };
  };

  config = {
    environment.systemPackages = [ pkgs.awww package ];

    desktop.wallpapers = {
      perWorkspace = {
        # DP-1 ultrawide
        "DP-1:1" = ../../assets/wallpaper/firefly-honkai-star-rail-8k-pq-3440x1440.jpg;
        "DP-1:2" = ../../assets/wallpaper/ray-arknights-bt-3440x1440.jpg;
        "DP-1:3" = ../../assets/wallpaper/zhuang.jpg;

        # DP-2 left content
        "DP-2:7" = ../../assets/wallpaper/arknights1.jpg;
        "DP-2:8" = ../../assets/wallpaper/valley4.jpg;
        "DP-2:9" = ../../assets/wallpaper/og_arknights.jpg;

        # HDMI-A-1 Graphic tablet
        # HDMI-A-2 mini screen
        "HDMI-A-2:4" = ../../assets/wallpaper/344628.jpg;
        "HDMI-A-2:5" = ../../assets/wallpaper/782218.jpg;
        "HDMI-A-2:6" = ../../assets/wallpaper/769152.jpg;
      };

      default = ../../assets/wallpaper/344628.jpg;
    };
  };
}
