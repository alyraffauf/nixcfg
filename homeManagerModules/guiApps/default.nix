{ config, lib, pkgs, ... }:

{
  imports = [ ./alacritty ./chromium ./firefox ./fuzzel ./librewolf ./mako ./waybar ];

  guiApps.firefox.enable = lib.mkDefault true;
  guiApps.alacritty.enable = lib.mkDefault true;
}
