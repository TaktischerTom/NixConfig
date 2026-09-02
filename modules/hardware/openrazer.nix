{ ... }:
{
  hardware.openrazer = {
    enable = true;

    batteryNotifier = {
      enable = true;
      percentage = 5;
      frequency = 600;
    };
  };
  hardware.openrazer.users = [ "tom" ];
}
