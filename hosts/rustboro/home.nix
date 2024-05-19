{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../aly.nix];
    alyraffauf = {
      services.easyeffects = {
        enable = true;
        preset = "LoudnessEqualizer.json";
      };
    };
  };
}
