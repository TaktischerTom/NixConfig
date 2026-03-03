{ ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall.allowedUDPPortRanges = [
    { from = 27031; to = 27036; }
  ];

  networking.firewall.allowedTCPPorts = [ 27036 27040 ];
}
