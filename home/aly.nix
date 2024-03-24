{ config, pkgs, ... }:

{
    imports = [
        ./gnome.nix
        ./shell.nix
        # ./sway.nix
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

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./dotfiles/hyprland.conf;
    };

    xdg.configFile."hypr/hypridle.conf".source = ./dotfiles/hypridle.conf;
    programs.waybar.enable = true;
    programs.waybar.settings = {
        mainBar = {
            layer = "top";
            position = "top";
            height = 36;
            output = [
                "eDP-1"
                "HDMI-A-1"
            ];
            modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
            modules-center = [ "hyprland/window" ];
            modules-right = [ "tray" "battery" "clock"];

            "hyprland/workspaces" = {
                all-outputs = true;
            };
            "clock" = {
                "interval" = 60;
                "format" = "{:%I:%M}";
            };
        };
    };


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
