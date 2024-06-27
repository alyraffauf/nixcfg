inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cpu
    ./gpu
    ./options.nix
    ./ssd
  ];
}
