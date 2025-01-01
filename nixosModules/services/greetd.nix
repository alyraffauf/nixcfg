{
  config,
  lib,
  pkgs,
  ...
}: {
  options.greetd = {
    autologin = lib.mkOption {
      description = "User to autologin.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    session = lib.mkOption {
      description = "Default command to execute on login.";
      default = lib.getExe config.programs.hyprland.package;
      type = lib.types.str;
    };
  };

  config = {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.greetd = {
      enable = true;

      settings =
        if config.greetd.autologin != null
        then {
          default_session = {
            command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.greetd.session}";
          };
          initial_session = {
            command = config.greetd.session;
            user = config.greetd.autologin;
          };
        }
        else {
          default_session = {
            command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.greetd.session}";
          };
        };
    };
  };
}
