_: {
  flake.nixosModules.gnome = {pkgs, ...}: {
    environment.systemPackages = [pkgs.gnomeExtensions.appindicator];

    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
