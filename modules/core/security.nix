{ ... }:
{
  security.polkit.enable = true;

  security.sudo.extraRules = [
    {
      users = [ "tom" ];
      commands = [
        { command = "/run/current-system/sw/bin/toHDMI"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/toDP"; options = [ "NOPASSWD" ]; } 
      ];
    }
  ];
}
