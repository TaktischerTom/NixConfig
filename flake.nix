{
  description = "Tom Config Flake";

  # all the git repos needed
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      # pass these in so we can access all the flake inputs in the config
      specialArgs = {inherit inputs self;};
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        {nixpkgs.hostPlatform = system;}
      ];
    };
  };
}
