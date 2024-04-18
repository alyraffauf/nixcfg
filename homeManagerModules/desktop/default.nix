{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./gnome ./hypr ./sway ./river];

  alyraffauf.desktop.hyprland.enable = lib.mkDefault true;
}
