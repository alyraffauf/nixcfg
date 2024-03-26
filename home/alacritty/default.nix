{ config, pkgs, ... }:

{
    programs.alacritty = {
        enable = true;
        settings = {
            colors = {
                primary = {
                    foreground = "#fafafa";
                    background = "#232634";
                };
                draw_bold_text_with_bright_colors = true;
            };
            font = {
                normal = { family = "NotoSansM Nerd Font"; style = "Regular"; };
                size = 10;
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
}
