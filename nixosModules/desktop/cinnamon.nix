{...}: {
  imports = [./gui.nix];

  services.xserver.desktopManager.cinnamon.enable = true;
}
