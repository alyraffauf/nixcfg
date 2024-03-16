{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ./common.nix
    ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.discover
    kdePackages.kate
    kdePackages.kimageformats
    kdePackages.kio-gdrive
    kdePackages.neochat
    maliit-keyboard
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
  ];

  programs.kdeconnect.enable = true;
#   nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
#   nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  services.packagekit.enable = true;
}
