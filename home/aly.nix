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
        # warp-terminal
        curl
        discord
        gh
        git
        github-desktop
        obsidian
        syncthing
        vscode
        wget
    ];

    programs.eza = {
        enable = true;
        git = true;
        extraOptions = [
            "--group-directories-first"
            "--header"
        ];
    };

    programs.fzf.enable = true;
    programs.nnn.enable = true;
    programs.tmux.enable = true;
}
