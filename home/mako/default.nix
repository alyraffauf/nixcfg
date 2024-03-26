{ config, pkgs, ... }:

{
    services.mako = {
      enable = true;
      font = "NotoSans Nerd Font Regular 10";
      backgroundColor = "#30344699";
      textColor = "#FAFAFA";
      borderRadius = 10;
      defaultTimeout = 10000;
      padding = "15";
    };
}
