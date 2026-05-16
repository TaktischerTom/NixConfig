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
  
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [
      { command = "/run/current-system/sw/bin/wg"; options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/wg-quick"; options = [ "NOPASSWD" ]; }
    ];
  }];
}
