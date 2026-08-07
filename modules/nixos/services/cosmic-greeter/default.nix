{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.cosmic-greeter.enable = lib.mkEnableOption "cosmic greeter display manager";

  config = lib.mkIf config.myNixOS.services.cosmic-greeter.enable {
    security.pam.services = {
      cosmic-greeter = {
        enableGnomeKeyring = true;
        gnupg.enable = true;
        kwallet.enable = true;
      };

      greetd = {
        fprintAuth = false;
      };
    };

    services.displayManager.cosmic-greeter.enable = true;
  };
}
