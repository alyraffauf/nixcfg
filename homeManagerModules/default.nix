inputs: self: {
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
    ./scripts
    ./services
    ./theme.nix
  ];
}
