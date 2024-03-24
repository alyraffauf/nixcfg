{ config, pkgs, ... }:

{
  imports = [ # Include X settings.
    ../desktop.nix
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    gnomeExtensions.light-shell
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.noannoyance-fork
    gnomeExtensions.tailscale-status
    gnomeExtensions.tiling-assistant
  ];

  # Enable keyring support for KDE apps in GNOME.
  security.pam.services.gdm.enableKwallet = true;

  # Enable GNOME and GDM.
  services = {
    gnome.tracker-miners.enable = true;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
