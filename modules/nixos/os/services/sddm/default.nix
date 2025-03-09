{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.sddm = {
    enable = lib.mkEnableOption "sddm display manager";

    autologin = lib.mkOption {
      description = "User to autologin.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.sddm.enable {
    security.pam.services.sddm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.displayManager = {
      autoLogin = lib.mkIf (config.myNixOS.services.sddm.autologin != null) {
        enable = true;
        user = config.myNixOS.services.sddm.autologin;
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
