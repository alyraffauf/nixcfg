_: {
  flake.nixosModules.default = {
    programs.dconf.enable = true;

    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
