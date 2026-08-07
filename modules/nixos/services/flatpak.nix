_: {
  flake.nixosModules.default = {pkgs, ...}: {
    services.flatpak.enable = true;

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
    };
  };
}
