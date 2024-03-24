{ config, pkgs, ... }:

{
    imports = [
        ./common.nix
        ./gnome
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
