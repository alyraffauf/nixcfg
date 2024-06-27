inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cpu
    ./gpu
    ./laptop
    ./options.nix
    ./ssd
    ./sound
  ];

  config = lib.mkIf config.ar.hardware.enable {
    hardware = {
      bluetooth.enable = true;

      keyboard.qmk.enable = true;

      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      steam-hardware.enable = config.programs.steam.enable;
    };

    services.logind.extraConfig = ''
      # Don't shutdown when power button is short-pressed
      HandlePowerKey=suspend
      HandlePowerKeyLongPress=poweroff
    '';
  };
}
