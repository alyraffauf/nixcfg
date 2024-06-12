{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.base.enable {
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

    sound.enable = true;
  };
}
