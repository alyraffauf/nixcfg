{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.ar.desktop.hyprland.enable || config.ar.desktop.sway.enable) {
    programs = {
      gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
    };

    services = {
      dbus.packages = [pkgs.gcr];
      gnome.gnome-keyring.enable = lib.mkDefault true;
      udev.packages = [pkgs.swayosd];
    };

    security.pam.services = {
      swaylock = {
        text = ''
          # Account management.
          account required pam_unix.so # unix (order 10900)

          # Authentication management.
          auth sufficient pam_unix.so likeauth try_first_pass likeauth nullok # unix (order 11500)
          ${
            lib.strings.optionalString config.services.fprintd.enable
            "auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so # fprintd (order 11300)"
          }

          auth required pam_deny.so # deny (order 12300)

          # Password management.
          password sufficient pam_unix.so nullok yescrypt # unix (order 10200)

          # Session management.
          session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
          session required pam_unix.so # unix (order 10200)
        '';
      };
    };
  };
}
