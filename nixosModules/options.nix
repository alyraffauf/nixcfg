{
  config,
  inputs,
  lib,
  pkgs,
  self,
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

    containers = {
      oci = {
        audiobookshelf = {
          enable = lib.mkEnableOption "audiobookshelf server in OCI container.";

          mediaDirectory = lib.mkOption {
            description = "Media directory for audiobookshelf.";
            default = "/mnt/Media";
            type = lib.types.str;
          };

          port = lib.mkOption {
            description = "Port for audiobookshelf.";
            default = 13378;
            type = lib.types.int;
          };
        };

        freshRSS = {
          enable = lib.mkEnableOption "FreshRSS news client in OCI container.";

          port = lib.mkOption {
            description = "Port for FreshRSS.";
            default = 8080;
            type = lib.types.int;
          };
        };

        jellyfin = {
          enable = lib.mkEnableOption "Jellyfin media server in OCI container.";

          archiveDirectory = lib.mkOption {
            description = "Archive directory for Jellyfin.";
            default = "/mnt/Archive";
            type = lib.types.str;
          };

          mediaDirectory = lib.mkOption {
            description = "Media directory for Jellyfin.";
            default = "/mnt/Media";
            type = lib.types.str;
          };

          port = lib.mkOption {
            description = "Port for Jellyfin.";
            default = 8096;
            type = lib.types.int;
          };
        };

        plexMediaServer = {
          enable = lib.mkEnableOption "Plex Media Server in OCI container.";

          archiveDirectory = lib.mkOption {
            description = "Archive directory for Plex Media Server.";
            default = "/mnt/Archive";
            type = lib.types.str;
          };

          mediaDirectory = lib.mkOption {
            description = "Media directory for Plex Media Server.";
            default = "/mnt/Media";
            type = lib.types.str;
          };

          port = lib.mkOption {
            description = "Port for Plex Media Server.";
            default = 32400;
            type = lib.types.int;
          };
        };

        transmission = {
          enable = lib.mkEnableOption "Transmission client in OCI container.";

          archiveDirectory = lib.mkOption {
            description = "Archive directory for Transmission.";
            default = "/mnt/Archive";
            type = lib.types.str;
          };

          bitTorrentPort = lib.mkOption {
            description = "Port for BitTorrent p2p services.";
            default = 5143;
            type = lib.types.int;
          };

          mediaDirectory = lib.mkOption {
            description = "Media directory for Transmission.";
            default = "/mnt/Media";
            type = lib.types.str;
          };

          port = lib.mkOption {
            description = "Port for Transmission.";
            default = 9091;
            type = lib.types.int;
          };
        };
      };
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

      navidrome = {
        enable = lib.mkEnableOption "Navidrome music server with secrets.";

        musicDirectory = lib.mkOption {
          description = "Music directory for Navidrome.";
          default = "/mnt/Media/Music";
          type = lib.types.str;
        };

        port = lib.mkOption {
          description = "Port for Navidrome.";
          default = 4533;
          type = lib.types.int;
        };
      };

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

    base = {
      enable =
        lib.mkEnableOption "Basic system configuration and sane defaults.";

      sambaAutoMount = lib.mkOption {
        description = "Automounting of mauville Samba Shares.";
        default =
          config.ar.services.tailscale.enable
          && !(config.networking.hostName == "mauville");
        type = lib.types.bool;
      };

      plymouth.enable = lib.mkOption {
        description = "Plymouth boot screen.";
        default = config.ar.base.enable;
        type = lib.types.bool;
      };

      zramSwap = {
        enable = lib.mkOption {
          description = "zram swap.";
          default = config.ar.base.enable;
          type = lib.types.bool;
        };

        size = lib.mkOption {
          description = "zram swap size relative to RAM.";
          default = 50;
          type = lib.types.int;
        };
      };
    };

    users = {
      defaultGroups = lib.mkOption {
        description = "Default groups for desktop users.";
        default = [
          "dialout"
          "docker"
          "libvirtd"
          "lp"
          "networkmanager"
          "scanner"
          "transmission"
          "video"
          "wheel"
        ];
      };

      aly = {
        enable = lib.mkEnableOption "Aly's user.";

        manageHome = lib.mkOption {
          description = "Whether to enable aly's home directory.";
          type = lib.types.bool;
          default = config.ar.users.aly.enable;
        };

        password = lib.mkOption {
          description = "Hashed password for aly.";
          type = lib.types.str;
        };
      };

      dustin = {
        enable = lib.mkEnableOption "Dustin's user.";

        manageHome = lib.mkOption {
          description = "Whether to manage dustin's home directory.";
          type = lib.types.bool;
          default = config.ar.users.dustin.enable;
        };

        password = lib.mkOption {
          description = "Hashed password for dustin.";
          type = lib.types.str;
        };
      };

      morgan = {
        enable = lib.mkEnableOption "Morgan's user.";

        manageHome = lib.mkOption {
          description = "Whether to manage morgan's home directory.";
          type = lib.types.bool;
          default = config.ar.users.morgan.enable;
        };

        password = lib.mkOption {
          description = "Hashed password for morgan.";
          type = lib.types.str;
        };
      };
    };
  };
}
