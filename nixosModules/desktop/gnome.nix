{...}: {
  imports = [./gui.nix];

  security.pam.services.gdm = {
    enableGnomeKeyring = true;
    gnupg.enable = true;
    kwallet.enable = true;
  };

  # Enable GNOME and GDM.
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
