{ config, pkgs, ... }:

{
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Noto Nerd Font Sans Mono";
          icon-theme = "breeze";
          layer = "overlay";
          terminal = "${pkgs.alacritty}/bin/alacritty -e";
        };
        colors.background = "#00000099";
        colors.selection = "#000000FF";
        colors.selection-match = "#FF0000FF";
        colors.selection-text = "#008000FF";
        colors.text = "#FFFFFFFF";
      };
    };
}
