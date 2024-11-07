{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.greetd.enable {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.greetd = {
      enable = true;

      settings =
        if config.ar.desktop.greetd.autologin != null
        then {
          default_session = {
            command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.ar.desktop.greetd.session}";
          };
          initial_session = {
            command = config.ar.desktop.greetd.session;
            user = config.ar.desktop.greetd.autologin;
          };
        }
        else {
          default_session = {
            command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.ar.desktop.greetd.session}";
          };
        };
    };
  };
}
