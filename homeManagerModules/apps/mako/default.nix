{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.mako.enable {
    services.mako = {
      enable = true;
      anchor = "top-center";
      backgroundColor = "${config.alyraffauf.theme.colors.background}CC";
      borderColor = "${config.alyraffauf.theme.colors.primary}EE";
      borderSize = 2;
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "${config.alyraffauf.theme.font.name} Regular ${toString config.alyraffauf.theme.font.size}";
      height = 300;
      layer = "top";
      padding = "15";
      textColor = "${config.alyraffauf.theme.colors.text}";
      width = 400;
      margin = "20,0";
      extraConfig = ''
        [mode=do-not-disturb]
        invisible=1
      '';
    };
  };
}
