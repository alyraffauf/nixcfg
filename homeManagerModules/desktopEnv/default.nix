{ config, lib, pkgs, ... }:

{
  imports = [ ./gnome ./hypr ];

  desktopEnv.hyprland.enable = lib.mkDefault true;
}
