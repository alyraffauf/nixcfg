{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        alyraffauf.services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer";
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
