{
  config,
  lib,
  ...
}: {
  imports = [./gui.nix];

  programs.firefox.policies.Preferences."browser.tabs.inTitlebar" = lib.mkIf (config.programs.firefox.enable) 1;

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
