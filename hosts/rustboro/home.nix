{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../homeManagerModules ../../aly.nix];
    alyraffauf = {
      desktop.sway.enable = true;
      services.easyeffects = {
        enable = true;
        preset = "LoudnessEqualizer.json";
      };
    };
    home.stateVersion = "23.11";
  };
}
