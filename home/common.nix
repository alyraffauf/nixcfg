{ config, pkgs, ... }:

{
  imports = [ ./shell ];
  home.username = "aly";
  home.homeDirectory = "/home/aly";

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  services.syncthing.enable = true;
}
