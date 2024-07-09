self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps
    ./desktop
    ./options.nix
    ./services
  ];
}
