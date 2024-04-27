# Lenovo Yoga 9i Convertible with Intel Core i7-1360P, 15GB RAM, 512GB SSD.
{
  config,
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

  pp-adjuster = pkgs.writeShellApplication {
    name = "pp-adjuster";

    runtimeInputs = [pkgs.libnotify pkgs.power-profiles-daemon];

    text = ''
      # Only works on petalburg.
      current_profile=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get | tr -d '[:space:]')

      if [ "$current_profile" == "power-saver" ]; then
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
      elif [ "$current_profile" == "balanced" ]; then
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
      elif [ "$current_profile" == "performance" ]; then
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      fi

      new_profile=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get | tr -d '[:space:]')
      ${pkgs.libnotify}/bin/notify-send "Power profile set to $new_profile."
    '';
  };
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

  environment.systemPackages = [cs-adjuster cs-adjuster-plasma pp-adjuster];

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
      aly.enable = true;
      dustin.enable = false;
    };
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = config.programs.sway.package + "/bin/sway";
      };
      sway.enable = true;
    };
    apps = {
      steam.enable = true;
    };
    services = {
      syncthing.enable = true;
    };
  };

  users.users.aly.hashedPassword = "$y$j9T$Ug0ZLHQQuRciFJDgOI6r00$eHc.KyQY0oU4k0LKRiZiGWJ19jkKNWHpOoyCJbtJif8";

  system.stateVersion = "23.11";
}
