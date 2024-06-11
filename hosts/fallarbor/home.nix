{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    users.aly = import ../../homes/aly.nix;
    users.dustin = import ../../homes/dustin.nix;
  };
}
