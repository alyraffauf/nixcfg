{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./budgie
    ./defaultApps.nix
    ./gnome
    ./hypr
    ./river
    ./sway
    ./theme.nix
  ];
}
