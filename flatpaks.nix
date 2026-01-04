# /etc/nixos/flatpaks.nix
{ config, pkgs, ... }:

{
  # Enable flatpak globally
  services.flatpak.enable = true;

  # Systemd service to add Flathub remote declaratively
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  systemd.services.flatpak-apps = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak install -y --system flathub dev.goats.xivlauncher
    '';
  };
}
