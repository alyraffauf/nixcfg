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
      default = inputs.hyprland.packages.${pkgs.system}.hyprland + "/bin/Hyprland";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.greetd.enable {
    services = {
      greetd = {
        enable = true;
        settings = rec {
          default_session = {
            command = lib.mkDefault "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${config.alyraffauf.desktop.greetd.session}";
          };
        };
      };
    };
  };
}
