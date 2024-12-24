{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.gnome.enable {
    security.pam.services.gdm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    # Enable GNOME and GDM.
    services = {
      gnome.localsearch.enable = true;
      udev.packages = with pkgs; [gnome-settings-daemon];

      xserver = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };
    };
  };
}
