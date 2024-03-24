{ config, pkgs, ... }:

{
    services.mako = {
      enable = true;
      font = "DroidSansM Nerd Font Mono 11";
      backgroundColor = "#00000080";
      textColor = "#FFFFFF";
      borderRadius = 10;
      defaultTimeout = 10000;
      padding = "15";
    };
}
