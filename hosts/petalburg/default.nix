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
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./home.nix
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "petalburg"; # Define your hostname.

  hardware.sensor.iio.enable = true;

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  environment.systemPackages = [ cs-adjuster cs-adjuster-plasma pp-adjuster ];

  desktopConfig = {
    enable = true;
    windowManagers.hyprland.enable = false;
    desktopEnvironments.gnome.enable = true;
  };

  systemConfig = {
    plymouth.enable = true;
    zramSwap = {
      enable = true;
    };
  };

  apps = {
    flatpak.enable = true;
    podman.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  system.stateVersion = "23.11";
}
