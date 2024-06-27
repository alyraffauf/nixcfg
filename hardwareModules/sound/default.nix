{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.sound {
    sound.enable = true;

    hardware.pulseaudio = {
      enable = lib.mkForce false;
      package = pkgs.pulseaudioFull;
    };

    services = {
      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
      };
    };
  };
}
