{ pkgs, ... }:
{
  systemd.settings.Manager.DefaultTimeoutStopSec = "20s";

  services = {
    getty.autologinUser = "tom";
    getty.autologinOnce = true;
  };

  services.blueman.enable = true;

  systemd.user.services.ydotoold = {
    description = "ydotool daemon";

    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %t/ydotoold";
      ExecStart = ''
        ${pkgs.ydotool}/bin/ydotoold \
          --socket-path=%t/ydotoold/socket \
          --socket-perm=0666
      '';
    };

    wantedBy = [ "default.target" ];
  };
}
