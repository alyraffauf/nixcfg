{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        border = {
          radius = 10;
          width = 2;
        };

        main = {
          font = "NotoSansM Nerd Font:size=${toString config.gtk.font.size}";
          icon-theme = "${config.gtk.iconTheme.name}";
          layer = "overlay";
          lines = 3;
          terminal = lib.getExe config.ar.home.defaultApps.terminal;
          width = 36;
        };

        colors = {
          background = "${config.ar.home.theme.colors.background}CC";
          border = "${config.ar.home.theme.colors.primary}EE";
          selection = "${config.ar.home.theme.colors.background}FF";
          selection-match = "${config.ar.home.theme.colors.primary}FF";
          selection-text = "${config.ar.home.theme.colors.secondary}FF";
          text = "${config.ar.home.theme.colors.text}FF";
        };
      };
    };
  };
}
