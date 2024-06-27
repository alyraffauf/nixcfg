{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "${config.ar.home.theme.terminalFont.name}:size=${toString config.ar.home.theme.terminalFont.size}";
          icon-theme = "${config.ar.home.theme.iconTheme.name}";
          layer = "overlay";
          lines = 3;
          terminal = config.ar.home.defaultApps.terminal.exe;
          width = 36;
        };
        border = {
          radius = 10;
          width = 2;
        };
        colors = {
          background = "${config.ar.home.theme.colors.background}CC";
          border = "${config.ar.home.theme.colors.primary}EE";
          selection = "${config.ar.home.theme.colors.background}FF";
          selection-match = "#e78284FF";
          selection-text = "#f4b8e4FF";
          text = "${config.ar.home.theme.colors.text}FF";
        };
      };
    };
  };
}
