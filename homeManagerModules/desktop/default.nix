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
    ./hyprland
    ./river
    ./sway
    ./theme.nix
  ];
}
