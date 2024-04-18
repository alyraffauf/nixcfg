{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../homeManagerModules];
    home.username = "aly";
    home.homeDirectory = "/home/aly";

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    alyraffauf.services.easyeffects = {
      enable = true;
      preset = "framework13.json";
    };
  };
}
