{
  config,
  lib,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = {
          draw_bold_text_with_bright_colors = true;

          primary = {
            background = "${cfg.theme.colors.background}";
            foreground = "${cfg.theme.colors.text}";
          };

          transparent_background_colors = true;
        };

        font = {
          normal = {
            family = cfg.theme.font.monospaceFont.name;
            style = "Regular";
          };

          size = cfg.theme.font.monospaceFont.size + 1;
        };

        selection.save_to_clipboard = true;

        window = {
          blur = true;
          decorations = "Full";
          dynamic_padding = true;
          opacity = 0.8;
        };
      };
    };
  };
}
