{
  pkgs,
  lib,
  config,
  ...
}: let
  gnomeCsAdjuster = pkgs.writeShellScriptBin "gnome-cs-adjuster" ''
    # Get current color scheme
    color_scheme=$(${lib.getExe' pkgs.glib "gsettings"} get org.gnome.desktop.interface color-scheme)

    # Toggle between light and dark color schemes
    if [ "$color_scheme" == "'default'" ] || [ "$color_scheme" == "'prefer-light'" ]; then
        color_scheme="'prefer-dark'"
    else
        color_scheme="'prefer-light'"
    fi

    # Apply the updated color scheme
    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface color-scheme $color_scheme
  '';
in {
  imports = [
    ./fprintdFix.nix
  ];

  config = lib.mkIf config.ar.desktop.gnome.enable {
    environment.systemPackages = with pkgs;
      [
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.gsconnect
        gnomeExtensions.light-shell
        gnomeExtensions.night-theme-switcher
        gnomeExtensions.noannoyance-fork
        gnomeExtensions.tailscale-status
        gnomeExtensions.tiling-assistant
      ]
      ++ [gnomeCsAdjuster];

    nixpkgs.overlays = [
      # GNOME 46: triple-buffering-v4-46
      (final: prev: {
        gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "vanvugt";
              repo = "mutter";
              rev = "triple-buffering-v4-46";
              hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
            };
          });
        });
      })
    ];

    # Enable keyring support for KDE apps in GNOME.
    security.pam.services.gdm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    # Enable GNOME and GDM.
    services = {
      gnome.tracker-miners.enable = true;
      udev.packages = with pkgs; [gnome.gnome-settings-daemon];
      xserver = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };
    };
  };
}
