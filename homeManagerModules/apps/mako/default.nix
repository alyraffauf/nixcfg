{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.mako.enable = lib.mkEnableOption "Mako notification daemon.";};

  config = lib.mkIf config.alyraffauf.apps.mako.enable {
    services.mako = {
      enable = true;
      anchor = "top-center";
      backgroundColor = "${config.alyraffauf.desktop.theme.colors.background}CC";
      borderColor = "${config.alyraffauf.desktop.theme.colors.primary}EE";
      borderSize = 2;
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "${config.alyraffauf.desktop.theme.font.name} Regular ${toString config.alyraffauf.desktop.theme.font.size}";
      height = 300;
      layer = "top";
      padding = "15";
      textColor = "${config.alyraffauf.desktop.theme.colors.text}";
      width = 400;
      margin = "20,0";
    };
  };
}
