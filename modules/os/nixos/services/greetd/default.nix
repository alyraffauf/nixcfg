{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.services.greetd = {
    enable = lib.mkEnableOption "greetd display manager";

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

  config = lib.mkIf config.myNixOS.services.greetd.enable {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
      kwallet.enable = true;
    };

    services.greetd = {
      enable = true;

      settings =
        if config.myNixOS.services.greetd.autologin != null
        then {
          default_session = {
            command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.myNixOS.services.greetd.session}";
          };

          initial_session = {
            command = config.myNixOS.services.greetd.session;
            user = config.myNixOS.services.greetd.autologin;
          };
        }
        else {
          default_session = {
            command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks --user-menu -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.myNixOS.services.greetd.session}";
          };
        };
    };
  };
}
