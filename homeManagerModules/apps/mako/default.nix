{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.mako.enable {
    services.mako = {
      enable = true;
      anchor = "top-center";
      backgroundColor = "${config.ar.home.theme.colors.background}CC";
      borderColor = "${config.ar.home.theme.colors.primary}EE";
      borderSize = 2;
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "${config.gtk.font.name} Regular ${toString config.gtk.font.size}";
      height = 300;
      layer = "top";
      padding = "15";
      textColor = "${config.ar.home.theme.colors.text}";
      width = 400;
      margin = "20,0";
      extraConfig = ''
        [mode=do-not-disturb]
        invisible=1
      '';
    };
  };
}
