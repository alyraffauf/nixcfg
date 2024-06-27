{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.ssd {
    services.fstrim.enable = true;
  };
}
