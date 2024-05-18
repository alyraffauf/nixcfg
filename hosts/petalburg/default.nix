# Lenovo Yoga 9i Convertible with Intel Core i7-1360P, 15GB RAM, 512GB SSD.
{
  config,
  lib,
  pkgs,
  ...
}: let
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
in {
  imports = [
    ./disko.nix
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

  environment.systemPackages = [cs-adjuster cs-adjuster-plasma];

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
      aly = {
        enable = true;
        password = "$y$j9T$TitXX3J690cnK41XciNMg/$APKHM/os6FKd9H9aXGxaHaQ8zP5SenO9EO94VYafl43";
      };
      dustin.enable = false;
    };
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = lib.getExe pkgs.sway;
        autologin = {
          enable = true;
          user = "aly";
        };
      };
      sway.enable = true;
    };
    apps = {
      steam.enable = true;
    };
    scripts = {
      hoenn.enable = true;
    };
    services = {
      syncthing.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
