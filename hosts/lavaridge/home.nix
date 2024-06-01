{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
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
    users.aly = import ../../aly.nix;
  };
}
