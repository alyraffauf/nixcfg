{ config, pkgs, ... }:

{
    services.mako = {
      enable = true;
      font = "NotoSans Nerd Font Regular 10";
      backgroundColor = "#00000099";
      textColor = "#FFFFFF";
      borderRadius = 10;
      defaultTimeout = 10000;
      padding = "15";
    };
}
