{ config, pkgs, ... }:

{
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
        # warp-terminal
        github-desktop
        obsidian
        vscode
        webcord
    ];
}
