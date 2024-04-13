{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./gnome ./hypr ./sway ./river];

  desktopEnv.hyprland.enable = lib.mkDefault true;
}
