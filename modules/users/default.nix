{ ... }:
{
  imports = [
    ./packages/development.nix
    ./packages/gaming.nix
    ./packages/desktop.nix
    ./packages/media.nix
    ./packages/utilities.nix
  ];

  users.users.tom = {
    isNormalUser = true;
    description = "Tom";
    extraGroups = [ "networkmanager" "wheel" "openrazer" "minecraft" ];
  };
}
