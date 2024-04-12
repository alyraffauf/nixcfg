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
    desktopConfig.displayManagers.lightdm.enable = lib.mkDefault false;

    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        };
      };
    };

    programs.hyprland.enable = true;
    programs.hyprland.package =
      inputs.hyprland.packages.${pkgs.system}.hyprland;

    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    services.dbus.packages = [pkgs.gcr];
    services.udev.packages = [pkgs.swayosd];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
