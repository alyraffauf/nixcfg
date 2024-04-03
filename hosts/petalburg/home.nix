{ inputs, config, pkgs, lib, ... }:

{
  home-manager.users.aly = {
    imports = [ ../../homeManagerModules ];
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    desktopEnv.hyprland.enable = true;
  };

  # userConfig.dustin.enable = true;
  # home-manager.users.dustin = {
  #   imports = [ ../../homeManagerModules ];
  #   home.username = "dustin";
  #   home.homeDirectory = "/home/dustin";

  #   home.stateVersion = "23.11";
  #   programs.home-manager.enable = true;
  # };
}
