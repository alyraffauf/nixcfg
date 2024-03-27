{ config, pkgs, ... }:

{
  imports = [ ./gnome ./common-gui.nix ];
  home.username = "dustin";
  home.homeDirectory = "/home/dustin";

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  services.syncthing.enable = true;
}
