{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.greetd.enable =
      lib.mkEnableOption "Enable greetd.";
    alyraffauf.desktop.greetd.session = lib.mkOption {
      description = "Default command to execute on login.";
      default = lib.getExe config.programs.hyprland.package;
      type = lib.types.str;
    };
    alyraffauf.desktop.greetd.autologin.enable = lib.mkOption {
      description = "Whether to enable autologin.";
      default = false;
      type = lib.types.bool;
    };
    alyraffauf.desktop.greetd.autologin.user = lib.mkOption {
      description = "User to autologin.";
      default = "aly";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.greetd.enable {
    services = {
      greetd = {
        enable = true;
        settings =
          if config.alyraffauf.desktop.greetd.autologin.enable
          then {
            default_session = {
              command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.alyraffauf.desktop.greetd.session}";
            };
            initial_session = {
              command = config.alyraffauf.desktop.greetd.session;
              user = config.alyraffauf.desktop.greetd.autologin.user;
            };
          }
          else {
            default_session = {
              command = lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --asterisks -g 'Welcome to NixOS ${config.system.nixos.release}' --time --remember --cmd ${config.alyraffauf.desktop.greetd.session}";
            };
          };
      };
    };
  };
}
