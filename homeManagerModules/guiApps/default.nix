{ config, lib, pkgs, ... }:

{
  imports = [ ./alacritty ./fuzzel ./librewolf ./mako ./waybar ];

  guiApps.librewolf.enable = lib.mkDefault true;
  guiApps.alacritty.enable = lib.mkDefault true;
}
