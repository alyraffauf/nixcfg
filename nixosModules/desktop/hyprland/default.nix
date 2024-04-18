{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.hyprland.enable =
      lib.mkEnableOption "Enable hyprland and greetd.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.enable {
    services = {
      dbus.packages = [pkgs.gcr];
      greetd = {
        enable = true;
        settings = rec {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          };
        };
      };
      udev.packages = [pkgs.swayosd];
    };

    security.pam.services = {
      greetd.enableKwallet = true;
      greetd.enableGnomeKeyring = true;
      swaylock = {};
    };

    programs = {
      gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      hyprland = {
        enable = true;
        package =
          inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
