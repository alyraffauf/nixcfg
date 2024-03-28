{ pkgs, lib, config, ... }: {

  options = { guiApps.fuzzel.enable = lib.mkEnableOption "Enables fuzzel."; };

  config = lib.mkIf config.guiApps.fuzzel.enable {
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
          background = "#232634CC";
          selection = "#232634FF";
          selection-match = "#e78284FF";
          selection-text = "#f4b8e4FF";
          text = "#fafafaFF";
        };
      };
    };
  };
}
