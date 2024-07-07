{
  config,
  lib,
  pkgs,
  ...
}: {
  options.ar = {
    apps = {
      firefox.enable = lib.mkEnableOption "Firefox Web Browser.";
      nicotine-plus.enable = lib.mkEnableOption "Nicotine+ Soulseek client.";
      podman.enable = lib.mkEnableOption "Podman for OCI container support.";
      steam.enable = lib.mkEnableOption "Valve's Steam for video games.";
      virt-manager.enable = lib.mkEnableOption "Virtual machine client.";
    };

    desktop = {
      cinnamon.enable = lib.mkEnableOption "Cinnamon desktop session.";

      gnome = {
        enable = lib.mkEnableOption "GNOME desktop session.";
        fprintdFix = lib.mkEnableOption "Fingerprint login fix for GDM";
      };

      greetd = {
        enable = lib.mkEnableOption "Greetd display manager.";

        autologin = {
          enable = lib.mkEnableOption "Whether to enable autologin.";

          user = lib.mkOption {
            description = "User to autologin.";
            default = "aly";
            type = lib.types.str;
          };
        };

        session = lib.mkOption {
          description = "Default command to execute on login.";
          default = lib.getExe config.programs.hyprland.package;
          type = lib.types.str;
        };
      };

      hyprland.enable = lib.mkEnableOption "Hyprland wayland session.";
      lightdm.enable = lib.mkEnableOption "Lightdm display manager.";
      plasma.enable = lib.mkEnableOption "Plasma desktop session.";
      steam.enable = lib.mkEnableOption "Steam + Gamescope session.";
      sway.enable = lib.mkEnableOption "Sway wayland session.";
    };

    services = {
      flatpak.enable = lib.mkEnableOption "Flatpak support with GUI.";

      syncthing = {
        enable = lib.mkEnableOption "Syncthing sync service.";

        user = lib.mkOption {
          description = "Specify user Syncthing runs as.";
          default = "aly";
          type = lib.types.str;
        };

        syncMusic = lib.mkOption {
          description = "Whether to sync music folder.";
          default = config.ar.services.syncthing.enable;
          type = lib.types.bool;
        };

        musicPath = lib.mkOption {
          description = "Whether to sync music folder.";
          default = "/home/${config.ar.services.syncthing.user}/music";
          type = lib.types.str;
        };
      };

      tailscale.enable = lib.mkEnableOption "Tailscale WireGuard VPN.";
    };
  };
}
