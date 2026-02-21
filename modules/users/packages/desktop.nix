{ pkgs, inputs, ... }:
{
  users.users.tom.packages = with pkgs; [
    # Quickshell
    (inputs.quickshell.packages.${pkgs.stdenv.system}.default.withModules [ kdePackages.qt5compat ])

    # Terminal & launcher
    foot
    tofi
    uwsm

    # Screenshots & color picking
    slurp
    grim
    grimblast
    hyprpicker
    swappy

    # Clipboard
    wl-clip-persist
    wl-clipboard
    xclip
    clipnotify

    # Display & input
    brightnessctl
    xorg.xrdb
    xorg.xrandr
    xorg.setxkbmap

    # Process management
    socat
    killall
  ];
}
