{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.desktop.sddm.enable {
    security.pam.services.sddm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.displayManager = {
      autoLogin = lib.mkIf (config.ar.desktop.sddm.autologin != null) {
        enable = true;
        user = config.ar.desktop.sddm.autologin;
      };

      sddm = {
        enable = true;

        wayland = {
          enable = true;
          compositor = "kwin";
        };
      };
    };
  };
}
