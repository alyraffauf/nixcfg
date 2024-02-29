{ config, pkgs, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kate
    yakuake
    libsForQt5.kio-gdrive
    libsForQt5.kimageformats
    libsForQt5.discover
  ];

  programs.kdeconnect.enable = true;
#   nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
#   nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  services.packagekit.enable = true;
}
