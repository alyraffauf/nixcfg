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
        alyraffauf.desktop.hyprland = {
          tabletMode.enable = true;
        };
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
