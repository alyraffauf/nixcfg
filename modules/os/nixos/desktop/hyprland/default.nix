{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [self.nixosModules.nixos-desktop];

  options.myNixOS.desktop.hyprland = {
    laptopMonitor = lib.mkOption {
      description = "Internal laptop monitor.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    monitors = lib.mkOption {
      description = "List of external monitors.";
      default = [];
      type = lib.types.listOf lib.types.str;
    };
  };

  config = {
    home-manager.sharedModules = [
      {
        myHome.desktop.hyprland = {
          enable = true;
          laptopMonitor = config.myNixOS.desktop.hyprland.laptopMonitor;
          monitors = config.myNixOS.desktop.hyprland.monitors;
        };

        wayland.windowManager.hyprland.settings.input = {
          kb_layout = lib.mkDefault config.services.xserver.xkb.layout;
          kb_options = lib.mkDefault config.services.xserver.xkb.options;
          kb_variant = lib.mkDefault config.services.xserver.xkb.variant;
        };
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
