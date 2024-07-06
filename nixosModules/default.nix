inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps
    ./base
    ./desktop
    ./options.nix
    ./services
    ./users
  ];
}
