# /etc/nixos/flatpaks.nix
{
  services.flatpak.enable = true;

  services.flatpak.remotes = {
    flathub = {
      url = "https://flathub.org/repo/flathub.flatpakrepo";
      system = true;
    };
  };

  services.flatpak.packages = [
    {
      name = "dev.goats.xivlauncher";
      remote = "flathub";
      system = true;
    }
  ];
}
