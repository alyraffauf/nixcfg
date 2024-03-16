{ config, pkgs, lib, ... }:

{
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = lib.mkForce false;
    # Enables extra codecs like aptx.
    package = pkgs.pulseaudioFull;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}