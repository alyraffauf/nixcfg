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
    users.aly = import ../../aly.nix;
    users.dustin = import ../../dustin.nix;
  };
}
