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
        alyraffauf.desktop.sway = {
          tabletMode.enable = true;
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
