{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../aly.nix];
    alyraffauf.desktop.sway = {
      tabletMode.enable = true;
    };
  };
}
