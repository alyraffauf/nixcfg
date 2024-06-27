inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cpu
    ./gpu
    ./laptop
    ./options.nix
    ./ssd
  ];
}
