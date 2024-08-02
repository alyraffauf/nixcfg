{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf (cfg.services.gammastep.enable || cfg.desktop.redShift) {
    services.gammastep = {
      enable = true;
      latitude = lib.mkDefault "33.74";
      longitude = lib.mkDefault "-84.38";
    };
  };
}
