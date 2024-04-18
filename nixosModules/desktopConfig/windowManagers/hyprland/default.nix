{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktopConfig.windowManagers.hyprland.enable =
      lib.mkEnableOption "Enables hyprland window manager session.";
  };

  config = lib.mkIf config.desktopConfig.windowManagers.hyprland.enable {
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
