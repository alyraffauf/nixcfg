{ config, pkgs, ... }:

{
    imports = [
        ../common.nix
    ];

    # TODO please change the username & home directory to your own
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    services.syncthing.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
	    vscode
        curl
        eza # A modern replacement for ‘ls’
        fzf # A command-line fuzzy finder
        gh
        git
        github-desktop
        syncthing
        todoist
        warp-terminal
        wget
    ];

    # basic configuration of git, please change to your own
    programs.git = {
        enable = true;
        userName = "Aly Raffauf";
        userEmail = "alyraffauf@gmail.com";
    };
}
