{
  config,
  lib,
  pkgs,
  ...
}: {
  options.raffauflabs = {
    enable = lib.mkEnableOption "Enable base hardware configuration.";

    domain = lib.mkOption {
      description = "Domain name to bind to.";
      default = "raffauflabs.com";
      type = lib.types.str;
    };

    email = lib.mkOption {
      description = "Email for ACME and other features.";
      default = "alyraffauf@gmail.com";
      type = lib.types.str;
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

    services = {
      forgejo.enable = lib.mkEnableOption "Git Forge + DevOps platform.";

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
    };
  };
}
