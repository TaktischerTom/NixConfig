{ ... }:
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./vpn-netns.nix
    ./locale.nix
    ./nix-settings.nix
    ./variables.nix
    ./security.nix
  ];
}
