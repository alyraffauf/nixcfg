# Lenovo Yoga 9i Convertible with Intel Core i7-1360P, 15GB RAM, 512GB SSD.

{ config, pkgs, ... }:

let
  cs-adjuster = pkgs.writeShellScriptBin "cs-adjuster" ''
    # Get current color scheme
    color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

    # Toggle between light and dark color schemes
    if [ "$color_scheme" == "'default'" ] || [ "$color_scheme" == "'prefer-light'" ]; then
        color_scheme="'prefer-dark'"
    else
        color_scheme="'prefer-light'"
    fi

    # Apply the updated color scheme
    gsettings set org.gnome.desktop.interface color-scheme $color_scheme
  '';

  cs-adjuster-plasma = pkgs.writeShellScriptBin "cs-adjuster-plasma" ''
    # Query the Desktop Portal Service for the current color scheme
    color_scheme=$(qdbus org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme)

    # Check the color scheme and apply the appropriate look and feel
    if [ "$color_scheme" = "1" ]; then
        plasma-apply-lookandfeel -a org.kde.breeze.desktop
    else
        plasma-apply-lookandfeel -a org.kde.breezedark.desktop
    fi
  '';

  pp-adjuster = pkgs.writeShellApplication {
    name = "pp-adjuster";

    runtimeInputs = [ pkgs.libnotify pkgs.power-profiles-daemon ];

    text = ''
      current_profile=$(powerprofilesctl get | tr -d '[:space:]')

      if [ "$current_profile" == "power-saver" ]; then
          powerprofilesctl set balanced
      elif [ "$current_profile" == "balanced" ]; then
          powerprofilesctl set performance
      elif [ "$current_profile" == "performance" ]; then
          powerprofilesctl set power-saver
      fi

      new_profile=$(powerprofilesctl get | tr -d '[:space:]')
      notify-send "Power profile set to $new_profile."
    '';
  };

in {
  imports = [
    # ../../modules/kde.nix
    ../../modules/gnome
    ../../modules/plymouth.nix
    ../../modules/zram_swap.nix
    ../../system
    ../../users/aly.nix
    ../../users/dustin.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pull latest Linux kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "petalburg"; # Define your hostname.

  hardware.sensor.iio.enable = true;

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  home-manager.users.aly = import ../../home/aly-gnome.nix;
  home-manager.users.dustin = import ../../home/dustin-gnome.nix;

  environment.systemPackages = [ cs-adjuster cs-adjuster-plasma pp-adjuster ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
