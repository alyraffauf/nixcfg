self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps
    ./defaultApps.nix
    ./desktop
    ./options.nix
    ./services
    ./theme.nix
  ];
}
