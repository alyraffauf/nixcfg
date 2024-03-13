{ config, pkgs, ... }:

{
    imports = [
        ../common.nix
    ];

    home.username = "nixos";
    home.homeDirectory = "/home/nixos";

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
        gparted
    ];
}
