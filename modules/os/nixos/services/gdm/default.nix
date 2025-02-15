{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.gdm = {
    enable = lib.mkEnableOption "gdm display manager";

    autologin = lib.mkOption {
      description = "User to autologin.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.gdm.enable {
    programs.dconf.profiles.gdm.databases = [
      {
        settings = {
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
            remember-numlock-state = true;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
          };
        };
      }
    ];

    security.pam.services.gdm = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.xserver.displayManager = {
      autoLogin = lib.mkIf (config.myNixOS.services.gdm.autologin != null) {
        enable = true;
        user = config.myNixOS.services.gdm.autologin;
      };

      gdm.enable = true;
    };
  };
}
