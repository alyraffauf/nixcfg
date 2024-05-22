{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    users.aly = import ../../aly.nix;
    users.dustin = import ../../dustin.nix;
  };
}
