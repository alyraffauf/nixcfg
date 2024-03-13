{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ../.
    ];

  # Enable Gnome and GDM.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  security.pam.services.gdm.enableKwallet = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.gnome.tracker-miners.enable = true;

  environment.systemPackages = with pkgs; [
    fractal
    gnome.gnome-software
  ];
}
