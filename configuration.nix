{ inputs, ... }:
{
  imports = [
    inputs.aagl.nixosModules.default
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./modules/core
    ./modules/hardware
    ./modules/desktop
    ./modules/programs
    ./modules/services
    ./modules/users
    ./modules/shell
  ];

  system.stateVersion = "25.05";
}
