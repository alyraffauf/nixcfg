{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../homeManagerModules ../../aly.nix];
    home.stateVersion = "23.11";
    alyraffauf = {
      services.syncthing.enable = true;
      desktop.sway = {
        enable = true;
        randomWallpaper = true;
      };
    };
  };
}
