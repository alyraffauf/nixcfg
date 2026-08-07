_: {
  flake.nixosModules.default = {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
  };
}
