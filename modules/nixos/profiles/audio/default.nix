{
  config,
  lib,
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

      pulseaudio.support32Bit = true;
    };

    myNixOS = {
      profiles.bluetooth.enable = true;
      services.avahi.enable = true;
    };
  };
}
