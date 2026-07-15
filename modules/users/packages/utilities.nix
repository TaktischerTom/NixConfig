{ pkgs, ... }:
{
  users.users.tom.packages = with pkgs; [
    # Shell enhancements
    zoxide
    fzf
    atuin
    btop
    evtest
    ydotool

    # File management
    ncdu
    filezilla
    zip
    _7zz
    unzip
    wget

    # System tools
    parted
    usbutils
    hyprpolkitagent
    usb-modeswitch

    # Communication
    thunderbird
    vesktop
    dialect

    # Security
    keepassxc

    # Devices
    openrazer-daemon
    razergenie
    oversteer

    # Language stuff
    anki

    # Custom wrappers
    (writeShellScriptBin "me3" "/home/tom/.local/bin/me3")

    
  ];
}
