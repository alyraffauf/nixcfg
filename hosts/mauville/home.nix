{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../homeManagerModules ../../aly.nix];
    xdg.userDirs.music = "/mnt/Media/Music";
    home.stateVersion = "23.11";
  };
}
