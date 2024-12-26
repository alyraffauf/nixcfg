{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.ar.desktop.hyprland.enable) {
    programs = {
      gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
    };

    services = {
      dbus.packages = [pkgs.gcr];
      gnome.gnome-keyring.enable = lib.mkDefault true;
      udev.packages = [pkgs.swayosd];
    };
  };
}
