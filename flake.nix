{
  description = "Tom Config Flake";

  # all the git repos needed
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";

      # Optional: Override the nixpkgs input of prismlauncher to use the same revision as the rest of your flake
      # Note that this may break the reproducibility mentioned above, and you might not be able to access the binary cache
      #
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    prismlauncher,
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
        {
          environment.systemPackages = [
            inputs.prismlauncher.packages.${system}.prismlauncher
          ];
        }
      ];
    };
  };
}
