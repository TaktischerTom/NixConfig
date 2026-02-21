{ pkgs, ... }:
{
  users.users.tom.packages = with pkgs; [
    # Shell enhancements
    zoxide
    fzf
    atuin
    btop

    # File management
    ncdu
    filezilla
    zip
    unzip
    wget

    # System tools
    parted
    usb-modeswitch
    usbutils

    # Communication
    thunderbird
    vesktop
    dialect

    # Security
    keepassxc

    # Razer peripherals
    openrazer-daemon
    razergenie

    # Custom wrappers
    (writeShellScriptBin "me3" "/home/tom/.local/bin/me3")
  ];
}
