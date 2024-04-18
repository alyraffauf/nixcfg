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
    alyraffauf.services.easyeffects = {
      enable = true;
      preset = "LoudnessEqualizer.json";
    };
    home.stateVersion = "23.11";
  };
}
