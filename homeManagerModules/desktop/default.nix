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
    ./waylandComp.nix
  ];
}
