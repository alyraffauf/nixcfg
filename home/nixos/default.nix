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
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.gsconnect
        gnomeExtensions.light-shell
        gnomeExtensions.night-theme-switcher
        gnomeExtensions.noannoyance-fork
        gnomeExtensions.tailscale-status
        gnomeExtensions.tiling-assistant
    ];
}
