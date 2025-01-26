{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [self.nixosModules.nixos-desktop];

  config = {
    home-manager.sharedModules = [
      {
        wayland.windowManager.hyprland.settings.input = {
          kb_layout = lib.mkDefault config.services.xserver.xkb.layout;
          kb_options = lib.mkDefault config.services.xserver.xkb.options;
          kb_variant = lib.mkDefault config.services.xserver.xkb.variant;
        };

        myHome.desktop.hyprland.enable = lib.mkDefault true;
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
