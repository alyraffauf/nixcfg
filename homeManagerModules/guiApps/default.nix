{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./chromium
    ./firefox
    ./fuzzel
    ./librewolf
    ./mako
    ./vsCodium
    ./waybar
  ];

  guiApps.firefox.enable = lib.mkDefault true;
  guiApps.alacritty.enable = lib.mkDefault true;
  guiApps.vsCodium.enable = lib.mkDefault true;
}
