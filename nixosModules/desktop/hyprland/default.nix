{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktop.hyprland.enable =
      lib.mkEnableOption "Enable hyprland and greetd.";
  };

  config = lib.mkIf config.desktop.hyprland.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        };
      };
    };

    security.pam.services.greetd.enableKwallet = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.pam.services.swaylock = {};

    programs.hyprland.enable = true;
    programs.hyprland.package =
      inputs.hyprland.packages.${pkgs.system}.hyprland;

    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

    services.dbus.packages = [pkgs.gcr];
    services.udev.packages = [pkgs.swayosd];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
