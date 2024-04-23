{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.sway.enable =
      lib.mkEnableOption "Enable sway wayland compositor.";
  };

  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    services = {
      dbus.packages = [pkgs.gcr];
      udev.packages = [pkgs.swayosd];
    };

    security.pam.services = {
      greetd.enableKwallet = true;
      greetd.enableGnomeKeyring = true;
      swaylock = {};
    };

    programs = {
      gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      sway = {
        enable = true;
        package = pkgs.swayfx;
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
