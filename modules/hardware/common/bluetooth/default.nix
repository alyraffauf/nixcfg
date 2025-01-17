{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    settings.General.AutoEnable = true;
  };

  services.pulseaudio = {
    package = pkgs.pulseaudioFull; # Use extra Bluetooth codecs like aptX

    extraConfig = ''
      load-module module-bluetooth-discover
      load-module module-bluetooth-policy
      load-module module-switch-on-connect
    '';

    support32Bit = true;
  };
}
