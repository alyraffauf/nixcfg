{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "${config.alyraffauf.theme.terminalFont.name}:size=${toString config.alyraffauf.theme.terminalFont.size}";
          icon-theme = "${config.alyraffauf.theme.iconTheme.name}";
          layer = "overlay";
          lines = 3;
          terminal = config.alyraffauf.defaultApps.terminal.exe;
          width = 36;
        };
        border = {
          radius = 10;
          width = 2;
        };
        colors = {
          background = "${config.alyraffauf.theme.colors.background}CC";
          border = "${config.alyraffauf.theme.colors.primary}EE";
          selection = "${config.alyraffauf.theme.colors.background}FF";
          selection-match = "#e78284FF";
          selection-text = "#f4b8e4FF";
          text = "${config.alyraffauf.theme.colors.text}FF";
        };
      };
    };
  };
}
