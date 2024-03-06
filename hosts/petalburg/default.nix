# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "petalburg"; # Define your hostname.

  hardware.sensor.iio.enable = true;

  powerManagement.powertop.enable = true;

  environment.systemPackages = [ cs-adjuster pp-adjuster ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
