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
    ./scripts
    ./services
    ./users
  ];
}
