{ pkgs, ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.extraConfig."10-clamp-line-boost" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "~alsa_card.pci-0000_00_1f.*";
            }
          ];
          actions = {
            update-props = {
              "api.alsa.headroom" = 0;
              "api.alsa.ignore-mixer" = true;
              "api.alsa.soft-mixer" = true;
            };
          };
        }
      ];
    };
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/30-steinberg-to-headset.conf" ''
        wireplumber.profiles = {
          main = {
            modules = [
              {
                name = libpipewire-module-loopback
                type = pw-module
                args = {
                  node.name = "switch_audio_loopback"
                  node.description = "Nintendo Switch Hardware Bridge"
                  
                  target.object = "alsa_output.usb-1532_Razer_Barracuda_X_R002000000-01.analog-stereo"
                  
                  capture.props = {
                    node.target = "alsa_input.usb-Yamaha_Corporation_Steinberg_UR22mkII-00.HiFi__Line2__source"
                    audio.position = [ MONO ]
                    stream.dont-remix = false
                    node.passive = true
                  }
                  
                  playback.props = {
                    media.class = "Stream/Output/Audio"
                    audio.position = [ FL FR ]
                    channelmix.upmix = true
                    channelmix.upmix-method = simple
                    node.passive = true
                  }
                }
              }
            ]
          }
        }
      '')
    ];
  };

  hardware.alsa.enablePersistence = true;
}
