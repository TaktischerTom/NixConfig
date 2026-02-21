{ inputs, ... }:
{
  nix.settings = inputs.aagl.nixConfig // { experimental-features = [ "nix-command" "flakes" ]; };

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/tom/SystemConfig";
  };
}
