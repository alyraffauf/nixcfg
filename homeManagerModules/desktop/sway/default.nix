{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.sway.enable {
    ar.home.theme.gtk.hideTitleBar =
      if config.wayland.windowManager.sway.package == pkgs.swayfx
      then false
      else true;

    wayland.windowManager.sway = import ./settings.nix {inherit config lib pkgs;};

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
  };
}
