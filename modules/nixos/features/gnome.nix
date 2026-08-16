_: {
  flake.nixosModules.gnome = {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
