{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.audio.enable = lib.mkEnableOption "audio support";

  config = lib.mkIf config.myNixOS.profiles.audio.enable {
    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
        raopOpenFirewall = true;

        extraConfig.pipewire = {
          "10-airplay" = {
            "context.modules" = [
              {
                name = "libpipewire-module-raop-discover";
              }
            ];
          };
        };
      };

      pulseaudio = {
        package = pkgs.pulseaudioFull; # Use extra Bluetooth codecs like aptX

        extraConfig = ''
          load-module module-bluetooth-discover
          load-module module-bluetooth-policy
          load-module module-switch-on-connect
        '';

        support32Bit = true;
      };
    };

    myNixOS.services.avahi.enable = true;
  };
}
