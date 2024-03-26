{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    anchor = "top-center";
    backgroundColor = "#232634CC";
    borderColor = "#ca9ee6";
    borderRadius = 10;
    defaultTimeout = 10000;
    font = "NotoSans Nerd Font Regular 10";
    height = 300;
    layer = "overlay";
    padding = "15";
    textColor = "#FAFAFA";
    width = 400;
  };
}
