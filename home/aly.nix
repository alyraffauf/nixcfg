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
        eza # A modern replacement for ‘ls’
        fzf # A command-line fuzzy finder
        gh
        git
        github-desktop
        syncthing
        vscode
        warp-terminal
        wget
    ];
}
