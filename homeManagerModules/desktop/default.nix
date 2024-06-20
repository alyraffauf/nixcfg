{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cinnamon
    ./gnome
    ./hyprland
    ./sway
    ./startupApps.nix
    ./waylandComp.nix
  ];
}
