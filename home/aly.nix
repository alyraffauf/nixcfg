{ config, pkgs, ... }:

{
    imports = [
        ./common.nix
        ./shell.nix
    ];

    # TODO please change the username & home directory to your own
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    services.syncthing.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
        # warp-terminal
        # backblaze-b2
        curl
        discord
        gh
        git
        github-desktop
        obsidian
        syncthing
        vscode
        wget
        nixfmt
    ];

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
                opacity = 0.8;
            };
        };
    };
}
