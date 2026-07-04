{ pkgs, ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.firewall.allowedUDPPortRanges = [
    { from = 27031; to = 27036; }
  ];

  networking.firewall.allowedTCPPorts = [ 27036 27040 ];

  # Required for WireGuard clients
  networking.firewall.checkReversePath = "loose";

  # NOTE: sudo rules for the VPN live in ./vpn-netns.nix, which drives the
  # network-namespace-based tunnel.
}
