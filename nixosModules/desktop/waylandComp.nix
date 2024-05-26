{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.waylandComp.enable =
      lib.mkEnableOption "Shared defaults for wayland compositors.";
  };

  config = lib.mkIf config.alyraffauf.desktop.waylandComp.enable {
    services = {
      blueman.enable = lib.mkDefault true;
      dbus.packages = [pkgs.gcr];
      geoclue2.enable = lib.mkDefault true;
      gnome.gnome-keyring.enable = lib.mkDefault true;
      udev.packages = [pkgs.swayosd];
    };

    security.pam.services = {
      swaylock = {};
    };

    programs = {
      gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
    };
  };
}
