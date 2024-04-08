{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./chromium
    ./firefox
    ./fractal
    ./fuzzel
    ./librewolf
    ./mako
    ./obsidian
    ./tauon
    ./thunderbird
    ./vsCodium
    ./waybar
    ./webCord
    ./wlogout
    ./zoom
  ];

  guiApps.alacritty.enable = lib.mkDefault true;
  guiApps.chromium.enable = lib.mkDefault true;
  guiApps.firefox.enable = lib.mkDefault true;
  guiApps.fractal.enable = lib.mkDefault true;
  guiApps.obsidian.enable = lib.mkDefault true;
  guiApps.tauon.enable = lib.mkDefault true;
  guiApps.thunderbird.enable = lib.mkDefault true;
  guiApps.vsCodium.enable = lib.mkDefault true;
  guiApps.webCord.enable = lib.mkDefault true;
  guiApps.zoom.enable = lib.mkDefault true;
}
