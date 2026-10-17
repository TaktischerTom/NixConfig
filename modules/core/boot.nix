{ pkgs,... }:
let theme = import ../../assets/theme.nix; in
{
  boot.loader = {
    systemd-boot = {
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;

    systemd-boot.enable = false;
    limine = {
      enable = true;
      # # edit this if you want to keep more configs
      maxGenerations = 5;
      style = {
        wallpapers = [../../assets/wallpaper/zhuang.jpg];
        wallpaperStyle = "centered";
        graphicalTerminal = {
          palette = "${theme.base00};${theme.base08};${theme.base0B};${theme.base0A};${theme.base0D};${theme.base0E};${theme.base0C};${theme.base04}";
          foreground = theme.base04;
          background = "40${theme.base00}";
          margin = 0;
        };
        interface.branding = "A Cozy Operating System";
        backdrop = theme.base00;
      };
      extraEntries = ''
        /Windows
            protocol: efi
            path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };

  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''
    KERNEL=="ntsync", MODE="0666"
  '';

  # Secure Boot
  environment.systemPackages = [pkgs.sbctl];
  boot.loader.limine.secureBoot.enable = true;
}
