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
        imports = [../../homeManagerModules];
        alyraffauf.services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer";
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
