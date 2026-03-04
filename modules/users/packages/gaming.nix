{ pkgs, inputs, ... }:
{
  users.users.tom.packages = with pkgs; [
    # Launchers & managers
    lutris
    bottles
    inputs.prismlauncher.packages.${pkgs.stdenv.system}.prismlauncher
    inputs.putah.packages.${pkgs.stdenv.system}.putah

    # Wine & Proton
    wineWowPackages.full
    protontricks
    steamtinkerlaunch

    # Emulators
    desmume
    waywall

    # VR
    alvr
    bs-manager
  ];

  # Waydroid
  virtualisation.waydroid = {
    enable = true;
    # necessary because kernel >= 6.17
    package = pkgs.waydroid-nftables;
  };
}
