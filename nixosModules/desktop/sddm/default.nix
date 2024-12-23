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

    services.displayManager.sddm = {
      enable = true;

      settings = {
        Autologin = lib.mkIf (config.ar.desktop.sddm.autologin != null) {
          Session = config.ar.desktop.sddm.session;
          User = config.ar.desktop.sddm.autologin;
        };

        wayland = {
          enable = true;
          compositor = "kwin";
        };
      };
    };
  };
}
