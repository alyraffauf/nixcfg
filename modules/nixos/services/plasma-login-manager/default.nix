{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.plasma-login-manager = {
    enable = lib.mkEnableOption "plasma-login-manager display manager";

    autoLogin = lib.mkOption {
      description = "User to autologin.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.plasma-login-manager.enable {
    security.pam.services.plasma-login-manager = {
      enableGnomeKeyring = true;
      fprintAuth = false;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.displayManager = {
      autoLogin = lib.mkIf (config.myNixOS.services.plasma-login-manager.autoLogin != null) {
        enable = true;
        user = config.myNixOS.services.plasma-login-manager.autoLogin;
      };

      plasma-login-manager.enable = true;
    };
  };
}
