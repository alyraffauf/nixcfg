{
  config,
  lib,
  ...
}: let
  cfg = config.myHome;
in {
  config = lib.mkIf cfg.apps.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = {
          draw_bold_text_with_bright_colors = true;
          transparent_background_colors = true;
        };

        selection.save_to_clipboard = true;

        window = {
          blur = true;
          decorations = "Full";
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };
  };
}
