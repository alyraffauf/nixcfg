{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./gnome ./hypr ./sway];

  desktopEnv.hyprland.enable = lib.mkDefault true;
}
