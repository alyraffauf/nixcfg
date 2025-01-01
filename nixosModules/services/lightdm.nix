{...}: {
  security.pam.services.lightdm = {
    enableGnomeKeyring = true;
    gnupg.enable = true;
    kwallet.enable = true;
  };

  services.xserver.displayManager.lightdm.enable = true;
}
