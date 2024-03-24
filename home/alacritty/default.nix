{ config, pkgs, ... }:

{
    programs.alacritty = {
        enable = true;
        settings = {
            colors = {
                primary = {
                    foreground = "#fafafa";
                    background = "#000000";
                };
                draw_bold_text_with_bright_colors = true;
            };
            font = {
                normal = { family = "DroidSansM Nerd Font Mono"; style = "Regular"; };
                size = 11;
            };
            selection.save_to_clipboard = true;
            window = {
                blur = true;
                # decorations = "None";
                dynamic_padding = true;
                opacity = 0.6;
            };
        };
    };
}
