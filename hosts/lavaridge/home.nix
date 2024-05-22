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
          preset = "framework13";
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
