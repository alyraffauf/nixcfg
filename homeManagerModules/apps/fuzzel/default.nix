{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.fuzzel.enable = lib.mkEnableOption "Enables fuzzel.";};

  config = lib.mkIf config.alyraffauf.apps.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "${config.alyraffauf.desktop.theme.terminalFont.name}:size=${toString config.alyraffauf.desktop.theme.terminalFont.size}";
          icon-theme = "${config.alyraffauf.desktop.theme.iconTheme.name}";
          layer = "overlay";
          lines = 3;
          terminal = config.alyraffauf.desktop.defaultApps.terminal.exe;
          width = 36;
        };
        border = {
          radius = 10;
          width = 2;
        };
        colors = {
          background = "${config.alyraffauf.desktop.theme.colors.background}CC";
          border = "${config.alyraffauf.desktop.theme.colors.primary}EE";
          selection = "${config.alyraffauf.desktop.theme.colors.background}FF";
          selection-match = "#e78284FF";
          selection-text = "#f4b8e4FF";
          text = "${config.alyraffauf.desktop.theme.colors.text}FF";
        };
      };
    };
  };
}
