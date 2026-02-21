{ pkgs, inputs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  programs.honkers-railway-launcher.enable = true;
  programs.anime-game-launcher.enable = true;

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  systemd.tmpfiles.rules = [
    "d /srv/minecraft 0755 minecraft minecraft -"
    "d /srv/minecraft/fabricLatest 0755 minecraft minecraft -"
  ];
}
