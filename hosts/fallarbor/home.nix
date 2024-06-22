{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    users.aly = import ../../homes/aly.nix;
    users.dustin = import ../../homes/dustin.nix;
  };
}
