inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps
    ./base
    ./containers
    ./desktop
    ./options.nix
    ./services
    ./users
  ];
}
