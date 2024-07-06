{
  config,
  lib,
  pkgs,
  ...
}: {
  options.raffauflabs = {
    enable = lib.mkEnableOption "Enable basic server configuration.";

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

          subDomain = lib.mkOption {
            description = "Subdomain for audiobookshelf.";
            default = "podcasts";
            type = lib.types.str;
          };
        };

        freshRSS = {
          enable = lib.mkEnableOption "FreshRSS news client in OCI container.";

          port = lib.mkOption {
            description = "Port for FreshRSS.";
            default = 8080;
            type = lib.types.int;
          };

          subDomain = lib.mkOption {
            description = "Subdomain for FreshRSS.";
            default = "news";
            type = lib.types.str;
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

          subDomain = lib.mkOption {
            description = "Subdomain for Plex.";
            default = "plex";
            type = lib.types.str;
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
      ddclient = {
        enable = lib.mkEnableOption "Enable ddclient for IP address updating.";

        protocol = lib.mkOption {
          description = "Protocol for ddclient authentication.";
          default = "cloudflare";
          type = lib.types.str;
        };

        passwordFile = lib.mkOption {
          description = "Secrets token for ddclient authentication.";
          type = lib.types.nonEmptyStr;
        };
      };

      forgejo = {
        enable = lib.mkEnableOption "Git Forge + DevOps platform.";

        subDomain = lib.mkOption {
          description = "Subdomain for Forgejo.";
          default = "git";
          type = lib.types.str;
        };
      };

      navidrome = {
        enable = lib.mkEnableOption "Navidrome music server with secrets.";

        lastfm.idFile = lib.mkOption {
          description = "Last.fm API key file.";
          type = lib.types.nonEmptyStr;
        };

        lastfm.secretFile = lib.mkOption {
          description = "Last.fm secret key file.";
          type = lib.types.nonEmptyStr;
        };

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

        spotify.idFile = lib.mkOption {
          description = "Spotify ID file.";
          type = lib.types.nonEmptyStr;
        };

        spotify.secretFile = lib.mkOption {
          description = "Spotify secret key file.";
          type = lib.types.nonEmptyStr;
        };

        subDomain = lib.mkOption {
          description = "Subdomain for navidrome.";
          default = "music";
          type = lib.types.str;
        };
      };
    };
  };
}
