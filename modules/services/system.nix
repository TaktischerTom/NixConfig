{ ... }:
{
  systemd.settings.Manager.DefaultTimeoutStopSec = "20s";

  services = {
    getty.autologinUser = "tom";
    getty.autologinOnce = true;
  };

  services.blueman.enable = true;
}
