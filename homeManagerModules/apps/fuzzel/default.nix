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
          radius = cfg.theme.borderRadius;
          width = 4;
        };

        main = {
          layer = "overlay";
          lines = 3;
          terminal = lib.getExe cfg.defaultApps.terminal;
          width = 36;
        };
      };
    };
  };
}
