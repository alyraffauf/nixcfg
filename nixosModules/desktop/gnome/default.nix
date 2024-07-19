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
  config = lib.mkIf config.ar.desktop.gnome.enable {
    environment.systemPackages =
      [
        pkgs.gnomeExtensions.appindicator
        pkgs.gnomeExtensions.blur-my-shell
        pkgs.gnomeExtensions.gsconnect
        pkgs.gnomeExtensions.light-shell
        pkgs.gnomeExtensions.night-theme-switcher
        pkgs.gnomeExtensions.noannoyance-fork
        pkgs.gnomeExtensions.tailscale-status
        pkgs.gnomeExtensions.tiling-assistant
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

    security.pam.services = {
      login.fprintAuth = false;

      gdm = {
        enableGnomeKeyring = true;
        gnupg.enable = true;
        kwallet.enable = true;
      };

      gdm-fingerprint = lib.mkIf (config.services.fprintd.enable) {
        text = ''
          auth       required                    pam_shells.so
          auth       requisite                   pam_nologin.so
          auth       requisite                   pam_faillock.so      preauth
          auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
          auth       optional                    pam_permit.so
          auth       required                    pam_env.so
          auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
          auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

          account    include                     login

          password   required                    pam_deny.so

          session    include                     login
          session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
        '';
      };
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
