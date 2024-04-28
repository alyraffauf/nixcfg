{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.fuzzel.enable = lib.mkEnableOption "Enables fuzzel.";};

  config = lib.mkIf config.alyraffauf.apps.fuzzel.enable {
    home.packages = with pkgs; [
      (nerdfonts.override {fonts = ["Noto"];})
      (catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "mauve";
      })
    ];

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "NotoSansMNerdFont-Regular";
          icon-theme = "Papirus-Dark";
          layer = "overlay";
          width = 50;
          terminal = "${pkgs.alacritty}/bin/alacritty";
        };
        border = {width = 2;};
        colors = {
          background = "#232634CC";
          selection = "#232634FF";
          selection-match = "#e78284FF";
          selection-text = "#f4b8e4FF";
          text = "#fafafaFF";
          border = "#ca9ee6aa";
        };
      };
    };
  };
}
