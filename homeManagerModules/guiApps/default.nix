{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./chromium
    ./firefox
    ./fuzzel
    ./librewolf
    ./mako
    ./vsCode
    ./waybar
  ];

  guiApps.firefox.enable = lib.mkDefault true;
  guiApps.alacritty.enable = lib.mkDefault true;
  guiApps.vsCode.enable = lib.mkDefault true;
}
