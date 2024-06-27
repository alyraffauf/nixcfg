{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.laptop {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
