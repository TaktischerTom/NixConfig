{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    roboto
    freetype
  ];

  fonts.fontconfig.defaultFonts = {
    serif = [ "Roboto" ];
    sansSerif = [ "Roboto" ];
    monospace = [ "RobotoMono Nerd Font" ];
    emoji = [ "Noto Color Emoji" ];
  };
}
