{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.greetd.enable {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };
    
    services = {
      greetd = {
        enable = true;
        settings =
          if config.alyraffauf.desktop.greetd.autologin.enable
          then {
            default_session = {
              command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.alyraffauf.desktop.greetd.session}";
            };
            initial_session = {
              command = config.alyraffauf.desktop.greetd.session;
              user = config.alyraffauf.desktop.greetd.autologin.user;
            };
          }
          else {
            default_session = {
              command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.alyraffauf.desktop.greetd.session}";
            };
          };
      };
    };
  };
}
