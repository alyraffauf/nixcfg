{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "NotoSansM Nerd Font";
        icon-theme = "breeze";
        layer = "overlay";
        terminal = "${pkgs.alacritty}/bin/alacritty -e";
      };
      border = { width = 2; };
      colors = {
        background = "#00000099";
        selection = "#000000FF";
        selection-match = "#FF0000FF";
        selection-text = "#008000FF";
        text = "#FFFFFFFF";
      };
    };
  };
}
