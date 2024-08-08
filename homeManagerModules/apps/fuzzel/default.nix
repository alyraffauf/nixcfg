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
          radius = 10;
          width = 2;
        };

        main = {
          font = "${cfg.theme.monospaceFont.name}:size=${cfg.theme.monospaceFont.size}";
          icon-theme = "${config.gtk.iconTheme.name}";
          layer = "overlay";
          lines = 3;
          terminal = lib.getExe cfg.defaultApps.terminal;
          width = 36;
        };

        colors = {
          background = "${cfg.theme.colors.background}CC";
          border = "${cfg.theme.colors.primary}EE";
          selection = "${cfg.theme.colors.background}FF";
          selection-match = "${cfg.theme.colors.primary}FF";
          selection-text = "${cfg.theme.colors.secondary}FF";
          text = "${cfg.theme.colors.text}FF";
        };
      };
    };
  };
}
