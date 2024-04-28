{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.alacritty.enable = lib.mkEnableOption "Enables alacritty.";
  };

  config = lib.mkIf config.alyraffauf.apps.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = {
          primary = {
            foreground = "#fafafa";
            background = "#232634";
          };
          transparent_background_colors = true;
          draw_bold_text_with_bright_colors = true;
        };
        font = {
          normal = {
            family = "NotoSansMNerdFont";
            style = "Regular";
          };
          size = 11;
        };
        selection.save_to_clipboard = true;
        window = {
          blur = true;
          # decorations = "None";
          dynamic_padding = true;
          opacity = 0.8;
        };
      };
    };
  };
}
