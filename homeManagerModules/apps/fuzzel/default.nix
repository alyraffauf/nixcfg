{
  config,
  lib,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        border = {
          radius = cfg.theme.borders.radius;
          width = 4;
        };

        main = {
          layer = "overlay";
          lines = 10;
          terminal = lib.getExe cfg.defaultApps.terminal;
          width = 24;
        };
      };
    };
  };
}
