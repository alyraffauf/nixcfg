{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = {
          primary = {
            background = "${config.alyraffauf.theme.colors.background}";
            foreground = "${config.alyraffauf.theme.colors.text}";
          };
          transparent_background_colors = true;
          draw_bold_text_with_bright_colors = true;
        };
        font = {
          normal = {
            family = "${config.alyraffauf.theme.terminalFont.name}";
            style = "Regular";
          };
          size = config.alyraffauf.theme.terminalFont.size;
        };
        selection.save_to_clipboard = true;
        window = {
          blur = true;
          decorations = "None";
          dynamic_padding = true;
          opacity = 0.8;
        };
      };
    };
  };
}
