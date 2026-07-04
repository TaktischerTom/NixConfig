{ pkgs, ... }:
{
  boot.kernelModules = [ "hid-logitech-hidpp" ];

  fileSystems."/home/tom/HDD" = {
    device = "/dev/disk/by-uuid/0c69e7a3-4d48-4a50-86f9-5b746c619dd9";
    fsType = "ext4";
  };

  hardware.usb-modeswitch.enable = true;

  services.udev.packages = [ pkgs.oversteer ];
   services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c26d", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c26d -M 0f00010142 -C 0x03 -m 01 -r 01"

    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c26e", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c26e", MODE="0666", RUN+="/bin/sh -c 'chmod 666 /sys/%p/range || true'"
  '';
}
