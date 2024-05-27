{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cinnamon
    ./defaultApps.nix
    ./gnome
    ./hyprland
    ./sway
    ./theme.nix
    ./waylandComp.nix
  ];
}
