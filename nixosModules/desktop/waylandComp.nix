{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.waylandComp {
    programs = {
      gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
    };

    services = {
      blueman.enable = lib.mkDefault true;
      dbus.packages = [pkgs.gcr];
      # geoclue2.enable = lib.mkDefault true;
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
            if config.services.fprintd.enable
            then "auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so # fprintd (order 11300)"
            else ""
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
