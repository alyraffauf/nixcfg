{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./randomWallpaper.nix];

  config = lib.mkIf config.ar.home.desktop.sway.enable {
    ar.home.theme.gtk.hideTitleBar =
      if config.wayland.windowManager.sway.package == pkgs.sway
      then true
      else false;

    wayland.windowManager.sway = import ./settings.nix {inherit config lib pkgs;};

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
  };
}
