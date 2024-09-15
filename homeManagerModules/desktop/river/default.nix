{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.river.enable {
    ar.home.theme.gtk.hideTitleBar = true;

    wayland.windowManager.river = import ./settings.nix {inherit config lib pkgs;};

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
  };
}
