{ pkgs, ... }:
{
  programs.firefox.enable = true;
  programs.thunar.enable = true;
  programs.yazi.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fontconfig
      freetype
      stdenv.cc.cc.lib
      
      libx11
      libxcursor
      libxext
      libxfixes
      libxi
      libxinerama
      libxrandr
      libxrender
      
      wayland
      libdecor
      libxkbcommon
      
      alsa-lib
      vulkan-loader
      libGL
    ];
  };
}
