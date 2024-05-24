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
          preset = "framework13";
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
