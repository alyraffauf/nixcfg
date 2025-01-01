{
  config,
  lib,
  ...
}: {
  options.sddm.autologin = lib.mkOption {
    description = "User to autologin.";
    default = null;
    type = lib.types.nullOr lib.types.str;
  };

  config = {
    security.pam.services.sddm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.displayManager = {
      autoLogin = lib.mkIf (config.sddm.autologin != null) {
        enable = true;
        user = config.sddm.autologin;
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
