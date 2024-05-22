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
        alyraffauf.desktop.sway = {
          tabletMode.enable = true;
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
