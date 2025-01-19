{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [self.nixosModules.nixos-desktop];

  config = {
    home-manager.sharedModules = [
      {
        ar.home.desktop.hyprland.enable = lib.mkDefault true;
      }
    ];

    programs = {
      gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      hyprland.enable = true;
      hyprlock.enable = true;
    };

    services = {
      dbus.packages = [pkgs.gcr];
      udev.packages = [pkgs.swayosd];
    };
  };
}
