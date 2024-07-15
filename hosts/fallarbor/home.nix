{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    {
      ar.home.desktop.hyprland.laptopMonitors = ["desc:BOE 0x095F,preferred,auto,1.566667"];
    }
  ];
}
