{ config, pkgs, ... }:

{
    imports = [
        ./common.nix
        ./shell
        ./hypr
        ./waybar
        ./mako
        ./bemenu
        ./alacritty
    ];

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
        # warp-terminal
        discord
        github-desktop
        obsidian
        vscode
    ];
}
