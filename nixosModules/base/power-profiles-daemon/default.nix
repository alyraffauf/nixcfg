{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.base.power-profiles-daemon.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
