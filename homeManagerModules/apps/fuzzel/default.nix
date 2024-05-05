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
          font = "${config.alyraffauf.desktop.theme.terminalFont.name}-Regular";
          icon-theme = "${config.alyraffauf.desktop.theme.iconTheme.name}";
          layer = "overlay";
          width = 36;
          lines = 3;
          terminal = "${pkgs.alacritty}/bin/alacritty";
        };
        border = {width = 2;};
        colors = {
          background = "${config.alyraffauf.desktop.theme.colors.background}CC";
          selection = "${config.alyraffauf.desktop.theme.colors.background}FF";
          selection-match = "#e78284FF";
          selection-text = "#f4b8e4FF";
          text = "${config.alyraffauf.desktop.theme.colors.text}FF";
          border = "${config.alyraffauf.desktop.theme.colors.primary}AA";
        };
      };
    };
  };
}
