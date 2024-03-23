{ config, pkgs, ... }:

{
    imports = [
        ./gnome.nix
        ./shell.nix
        ./sway.nix
    ];

    home.username = "aly";
    home.homeDirectory = "/home/aly";

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
        # warp-terminal
        discord
        github-desktop
        obsidian
        vscode
    ];

    services.syncthing.enable = true;

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
