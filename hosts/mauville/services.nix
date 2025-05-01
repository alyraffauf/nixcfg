{config, ...}: let
  # navidrome = {
  #   port = 4533;
  #   lastfm = {
  #     idFile = config.age.secrets.lastfmId.path;
  #     secretFile = config.age.secrets.lastfmSecret.path;
  #   };
  #   spotify = {
  #     idFile = config.age.secrets.spotifyId.path;
  #     secretFile = config.age.secrets.spotifySecret.path;
  #   };
  # };
in {
  environment.etc = {
    "fail2ban/filter.d/audiobookshelf.conf".text = ''
      [Definition]
      failregex = \[.*\] ERROR: \[Auth\] Failed login attempt for username \".*\" from ip <HOST> \(User not found\)
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=audiobookshelf.service
    '';

    # "fail2ban/filter.d/navidrome.conf".text = ''
    #   [INCLUDES]
    #   before = common.conf

    #   [Definition]
    #   failregex = msg="Unsuccessful login".*X-Real-Ip:\[<HOST>\]
    #   ignoreregex =
    #   journalmatch = _SYSTEMD_UNIT=navidrome.service
    # '';
  };

  networking = {
    firewall.allowedTCPPorts = [80 443 2379 2380 3000 6443 61208];
    firewall.allowedUDPPorts = [8472];
  };

  services = {
    audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 13378;
    };

    fail2ban = {
      enable = true;
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;

      jails = {
        audiobookshelf = ''
          enabled = true
          backend = systemd
          filter = audiobookshelf
          maxretry = 5
          port = 80,443,${toString config.services.audiobookshelf.port}
        '';

        # navidrome = ''
        #   enabled = true
        #   backend = systemd
        #   filter = navidrome
        #   maxretry = 5
        #   port = 0,443,${toString navidrome.port}
        # '';
      };
    };

    forgejo = {
      enable = true;
      lfs.enable = true;
      stateDir = "/mnt/Storage/forgejo";

      settings = {
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://github.com";
        };

        cron = {
          ENABLED = true;
          RUN_AT_START = false;
        };

        DEFAULT.APP_NAME = "Forĝejo";

        repository = {
          DEFAULT_BRANCH = "master";
          ENABLE_PUSH_CREATE_ORG = true;
          ENABLE_PUSH_CREATE_USER = true;
          PREFERRED_LICENSES = "GPL-3.0";
        };

        federation.ENABLED = true;
        picture.ENABLE_FEDERATED_AVATAR = true;
        security.PASSWORD_CHECK_PWN = true;

        server = {
          LANDING_PAGE = "explore";
          ROOT_URL = "https://forgejo.cute.haus/";
        };

        service = {
          ALLOW_ONLY_INTERNAL_REGISTRATION = true;
          DISABLE_REGISTRATION = true;
          ENABLE_NOTIFY_MAIL = true;
        };

        session.COOKIE_SECURE = true;
        ui.DEFAULT_THEME = "forgejo-auto";

        "ui.meta" = {
          AUTHOR = "Forĝejo @ cute.haus";
          DESCRIPTION = "Self-hosted git forge for projects + toys.";
          KEYWORDS = "git,source code,forge,forĝejo,aly raffauf";
        };
      };
    };

    # navidrome = {
    #   enable = true;
    #   openFirewall = true;
    # };

    # slskd = {
    #   enable = true;
    #   domain = "0.0.0.0";
    #   environmentFile = config.age.secrets.slskd.path;
    #   openFirewall = true;

    #   settings = {
    #     directories.downloads = "/mnt/Media/Inbox/Music";
    #     shares.directories = ["/mnt/Media/Music"];
    #     soulseek.connection.buffer.read = 4096;
    #     soulseek.connection.buffer.write = 4096;
    #     soulseek.connection.buffer.transfer = 81920;
    #     soulseek.distributedNetwork.childLimit = 10;

    #     global = {
    #       download = {
    #         limit = 500; # Limit downloads to 500 KB/s
    #         slots = 4;
    #       };

    #       limits = {
    #         daily.megabytes = 1024; # Limit daily uplolads to 1GB
    #         weekly.megabytes = 10240; # Limit weekly uploads to 10GB
    #       };

    #       upload = {
    #         limit = 320; # Limit uploads to 32 KB/s
    #         slots = 4;
    #       };
    #     };
    #   };
    # };
  };

  systemd.services = {
    forgejo = {
      wants = ["network-online.target" "mnt-Data.mount"];
      after = ["network-online.target" "mnt-Data.mount"];
    };
  };

  # systemd.services = {
  #   navidrome.serviceConfig = let
  #     navidromeConfig = builtins.toFile "navidrome.json" (lib.generators.toJSON {} {
  #       Address = "0.0.0.0";
  #       DefaultTheme = "Auto";
  #       MusicFolder = musicDirectory;
  #       Port = navidrome.port;
  #       SubsonicArtistParticipations = true;
  #       UIWelcomeMessage = "Welcome to Navidrome @ ${domain}";
  #       "Spotify.ID" = "@spotifyClientId@";
  #       "Spotify.Secret" = "@spotifyClientSecret@";
  #       "LastFM.Enabled" = true;
  #       "LastFM.ApiKey" = "@lastFMApiKey@";
  #       "LastFM.Secret" = "@lastFMSecret@";
  #       "LastFM.Language" = "en";
  #     });

  #     navidrome-secrets = pkgs.writeShellScript "navidrome-secrets" ''
  #       lastFMApiKey=$(cat "${navidrome.lastfm.idFile}")
  #       lastFMSecret=$(cat "${navidrome.lastfm.secretFile}")
  #       spotifyClientId=$(cat "${navidrome.spotify.idFile}")
  #       spotifyClientSecret=$(cat "${navidrome.spotify.secretFile}")
  #       ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
  #         -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
  #         ${navidromeConfig} > /var/lib/navidrome/navidrome.json
  #     '';
  #   in {
  #     BindReadOnlyPaths = [
  #       navidrome.lastfm.idFile
  #       navidrome.lastfm.secretFile
  #       navidrome.spotify.idFile
  #       navidrome.spotify.secretFile
  #       musicDirectory
  #     ];

  #     ExecStartPre = navidrome-secrets;
  #     ExecStart = lib.mkForce ''
  #       ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
  #         --datafolder /var/lib/navidrome/
  #     '';
  #   };
  # };
}
