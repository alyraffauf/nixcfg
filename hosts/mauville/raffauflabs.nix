{
  config,
  lib,
  pkgs,
  ...
}: let
  audiobookshelf.port = 13378;
  domain = "raffauflabs.com";
  mediaDirectory = "/mnt/Media";
  musicDirectory = "${mediaDirectory}/Music";

  navidrome = {
    port = 4533;

    lastfm = {
      idFile = config.age.secrets.lastfmId.path;
      secretFile = config.age.secrets.lastfmSecret.path;
    };

    spotify = {
      idFile = config.age.secrets.spotifyId.path;
      secretFile = config.age.secrets.spotifySecret.path;
    };
  };

  transmission = {
    port = 9091;
    bitTorrentPort = 5143;
  };
in {
  environment.etc = {
    "fail2ban/filter.d/audiobookshelf.conf".text = ''
      [Definition]
      failregex = \[.*\] ERROR: \[Auth\] Failed login attempt for username \".*\" from ip <HOST> \(User not found\)
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=audiobookshelf.service
    '';

    "fail2ban/filter.d/navidrome.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = msg="Unsuccessful login".*X-Real-Ip:\[<HOST>\]
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=navidrome.service
    '';
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
      port = audiobookshelf.port;
    };

    fail2ban = {
      enable = true;
      bantime = "24h";
      bantime-increment.enable = true;

      jails = {
        audiobookshelf = ''
          enabled = true
          backend = systemd
          filter = audiobookshelf
          maxretry = 5
          port = 13378,80,443
        '';

        navidrome = ''
          enabled = true
          backend = systemd
          filter = navidrome
          maxretry = 5
          port = 4533,80,443
        '';
      };
    };

    # forgejo = {
    #   enable = true;
    #   lfs.enable = true;

    #   settings = {
    #     actions = {
    #       ENABLED = true;
    #       DEFAULT_ACTIONS_URL = "https://github.com";
    #     };

    #     cron = {
    #       ENABLED = true;
    #       RUN_AT_START = false;
    #     };

    #     DEFAULT.APP_NAME = "Forĝejo";

    #     repository = {
    #       DEFAULT_BRANCH = "master";
    #       ENABLE_PUSH_CREATE_ORG = true;
    #       ENABLE_PUSH_CREATE_USER = true;
    #       PREFERRED_LICENSES = "GPL-3.0";
    #     };

    #     federation.ENABLED = true;
    #     picture.ENABLE_FEDERATED_AVATAR = true;
    #     security.PASSWORD_CHECK_PWN = true;

    #     server = {
    #       LANDING_PAGE = "explore";
    #       ROOT_URL = "https://git.${domain}/";
    #     };

    #     service = {
    #       ALLOW_ONLY_INTERNAL_REGISTRATION = true;
    #       DISABLE_REGISTRATION = true;
    #       ENABLE_NOTIFY_MAIL = true;
    #     };

    #     session.COOKIE_SECURE = true;

    #     ui.DEFAULT_THEME = "forgejo-auto";
    #     "ui.meta" = {
    #       AUTHOR = "Forĝejo @ ${domain}";
    #       DESCRIPTION = "Self-hosted git forge for projects + toys.";
    #       KEYWORDS = "git,source code,forge,forĝejo,aly raffauf";
    #     };
    #   };
    # };

    immich = {
      enable = true;
      host = "0.0.0.0";
      mediaLocation = "${mediaDirectory}/Pictures";
      openFirewall = true;
    };

    # k3s = {
    #   enable = true;
    #   role = "server";
    #   tokenFile = config.age.secrets.k3s.path;
    #   serverAddr = "https://192.168.0.104:6443";
    # };

    navidrome = {
      enable = true;
      openFirewall = true;
    };

    plex = {
      enable = true;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      credentialsFile = config.age.secrets.transmission.path;
      openFirewall = true;
      openRPCPort = true;

      settings = {
        blocklist-enabled = true;
        blocklist-url = "https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/bt_blocklists.gz";
        download-dir = mediaDirectory;
        peer-port = transmission.bitTorrentPort;
        rpc-bind-address = "0.0.0.0";
        rpc-port = transmission.port;
      };
    };
  };

  systemd.services = {
    glances = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      path = [pkgs.glances];
      script = "glances --webserver --bind 0.0.0.0 --port 61208";
    };

    navidrome.serviceConfig = let
      navidromeConfig = builtins.toFile "navidrome.json" (lib.generators.toJSON {} {
        Address = "0.0.0.0";
        DefaultTheme = "Auto";
        MusicFolder = musicDirectory;
        Port = navidrome.port;
        SubsonicArtistParticipations = true;
        UIWelcomeMessage = "Welcome to Navidrome @ ${domain}";
        "Spotify.ID" = "@spotifyClientId@";
        "Spotify.Secret" = "@spotifyClientSecret@";
        "LastFM.Enabled" = true;
        "LastFM.ApiKey" = "@lastFMApiKey@";
        "LastFM.Secret" = "@lastFMSecret@";
        "LastFM.Language" = "en";
      });

      navidrome-secrets = pkgs.writeShellScript "navidrome-secrets" ''
        lastFMApiKey=$(cat "${navidrome.lastfm.idFile}")
        lastFMSecret=$(cat "${navidrome.lastfm.secretFile}")
        spotifyClientId=$(cat "${navidrome.spotify.idFile}")
        spotifyClientSecret=$(cat "${navidrome.spotify.secretFile}")
        ${pkgs.gnused}/bin/sed -e "s/@lastFMApiKey@/$lastFMApiKey/" -e "s/@lastFMSecret@/$lastFMSecret/" \
          -e "s/@spotifyClientId@/$spotifyClientId/" -e "s/@spotifyClientSecret@/$spotifyClientSecret/" \
          ${navidromeConfig} > /var/lib/navidrome/navidrome.json
      '';
    in {
      BindReadOnlyPaths = [
        navidrome.lastfm.idFile
        navidrome.lastfm.secretFile
        navidrome.spotify.idFile
        navidrome.spotify.secretFile
        musicDirectory
      ];

      ExecStartPre = navidrome-secrets;
      ExecStart = lib.mkForce ''
        ${config.services.navidrome.package}/bin/navidrome --configfile /var/lib/navidrome/navidrome.json \
          --datafolder /var/lib/navidrome/
      '';
    };
  };
}
