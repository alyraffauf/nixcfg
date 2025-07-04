{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland desktop environment";

    laptopMonitor = lib.mkOption {
      description = "Internal laptop monitor.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    monitors = lib.mkOption {
      description = "List of external monitors.";

      default = [
        "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-1920x0,2.0"
        "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
        "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
      ];

      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.desktop.hyprland.enable {
    home-manager.sharedModules = [
      {
        myHome.desktop.hyprland = {
          enable = true;
          inherit (config.myNixOS.desktop.hyprland) laptopMonitor;
          inherit (config.myNixOS.desktop.hyprland) monitors;
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

    system.nixos.tags = ["hyprland"];

    myNixOS.desktop.enable = true;
  };
}
