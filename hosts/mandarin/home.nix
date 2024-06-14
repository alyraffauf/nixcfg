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
          desktop = {
            hyprland.autoSuspend = false;
            sway.autoSuspend = false;
          };
        };
      }
    ];
    users.aly = import ../../homes/aly.nix;
    users.morgan = import ../../homes/morgan.nix;
  };
}
