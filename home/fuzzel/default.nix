{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "NotoSansM Nerd Font Regular";
        icon-theme = "Papirus-Dark";
        layer = "overlay";
        terminal = "${pkgs.alacritty}/bin/alacritty -e";
      };
      border = { width = 2; };
      colors = {
        background = "#23263499";
        selection = "#232634FF";
        selection-match = "#e78284FF";
        selection-text = "#f4b8e4FF";
        text = "#fafafaFF";
      };
    };
  };
}
