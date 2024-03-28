{ pkgs, lib, config, ... }: {

  options = { guiApps.mako.enable = lib.mkEnableOption "Enables mako."; };

  config = lib.mkIf config.guiApps.mako.enable {
    services.mako = {
      enable = true;
      anchor = "top-center";
      backgroundColor = "#232634CC";
      borderColor = "#ca9ee6";
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "NotoSans Nerd Font Regular 10";
      height = 300;
      layer = "top";
      padding = "15";
      textColor = "#FAFAFA";
      width = 400;
      margin = "20,0";
    };
  };
}
