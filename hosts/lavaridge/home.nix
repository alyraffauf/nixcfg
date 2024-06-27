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
        ar.home = {
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
