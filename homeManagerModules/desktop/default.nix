{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./budgie
    ./cinnamon
    ./defaultApps.nix
    ./gnome
    ./hypr
    ./river
    ./sway
    ./theme.nix
  ];
}
