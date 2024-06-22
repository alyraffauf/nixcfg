{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        alyraffauf = {
          services.easyeffects = {
            enable = true;
            preset = "framework13";
          };
        };
      }
    ];
    users.aly = import ../../homes/aly.nix;
  };
}
