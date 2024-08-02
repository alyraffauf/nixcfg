{
  config,
  lib,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.gammastep.enable {
    services.gammastep = {
      enable = true;
      latitude = lib.mkDefault "33.74";
      longitude = lib.mkDefault "-84.38";
    };
  };
}
