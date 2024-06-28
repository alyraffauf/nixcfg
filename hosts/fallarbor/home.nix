{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    users.aly = import ../../homes/aly;
    users.dustin = import ../../homes/dustin;
  };
}
