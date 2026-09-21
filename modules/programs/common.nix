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
      
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      
      wayland
      libdecor
      libxkbcommon
      
      alsa-lib
      vulkan-loader
      libGL
    ];
  };
}
