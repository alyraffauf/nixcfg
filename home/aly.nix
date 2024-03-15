{ config, pkgs, ... }:

{
    imports = [
        ./common.nix
    ];

    # TODO please change the username & home directory to your own
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    services.syncthing.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
        curl
        gh
        git
        github-desktop
        syncthing
        vscode
        # warp-terminal
        wget
    ];

    programs.eza = {
        enable = true;
        git = true;
    }

    programs.fzf.enable = true;
    programs.nnn.enable = true;
    programs.tmux.enable = true;
}
