{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.gnome.fprintdFix.enable =
      lib.mkEnableOption
      "Fix fprintd and pam issues with GNOME Display Manager.";
  };

  config = lib.mkIf config.alyraffauf.desktop.gnome.fprintdFix.enable {
    # Need to change the order pam loads its modules
    # to get proper fingerprint behavior on GDM and the lockscreen.
    security.pam.services = {
      login.fprintAuth = false;
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
  };
}
