{config, ...}: {
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

    caddy.virtualHosts = {
      "${config.mySnippets.tailnet.networkMap.grafana.vHost}" = {
        extraConfig = ''
          bind tailscale/grafana
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.grafana.hostName}:${toString config.mySnippets.tailnet.grafana.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.loki.vHost}" = {
        extraConfig = ''
          bind tailscale/loki
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.loki.hostName}:${toString config.mySnippets.tailnet.loki.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.prometheus.vHost}" = {
        extraConfig = ''
          bind tailscale/prometheus
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.prometheus.hostName}:${toString config.mySnippets.tailnet.prometheus.port}
        '';
      };
    };

    glance = {
      enable = true;
      openFirewall = true;

      settings = {
        pages = [
          {
            name = config.mySnippets.cute-haus.networkMap.glance.vHost;
            width = "slim";
            hide-desktop-navigation = true;
            center-vertically = true;
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    autofocus = true;
                  }
                  {
                    type = "monitor";
                    cache = "1m";
                    title = "Public Services";

                    sites = [
                      {
                        title = "Plex";
                        url = "https://${config.mySnippets.cute-haus.networkMap.plex.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.plex.hostName}:${toString config.mySnippets.cute-haus.networkMap.plex.port}/web/index.html";
                        icon = "di:plex";
                      }
                      {
                        title = "Ombi";
                        url = "https://${config.mySnippets.cute-haus.networkMap.ombi.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.ombi.hostName}:${toString config.mySnippets.cute-haus.networkMap.ombi.port}/";
                        icon = "di:ombi";
                      }
                      {
                        title = "Audiobookshelf";
                        url = "https://${config.mySnippets.cute-haus.networkMap.audiobookshelf.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.audiobookshelf.hostName}:${toString config.mySnippets.cute-haus.networkMap.audiobookshelf.port}/";
                        icon = "di:audiobookshelf";
                      }
                      {
                        title = "Immich";
                        url = "https://${config.mySnippets.cute-haus.networkMap.immich.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.immich.hostName}:${toString config.mySnippets.cute-haus.networkMap.immich.port}/";
                        icon = "di:immich";
                      }
                      {
                        title = "Forĝejo";
                        url = "https://${config.mySnippets.cute-haus.networkMap.forgejo.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.forgejo.hostName}:${toString config.mySnippets.cute-haus.networkMap.forgejo.port}/";
                        icon = "di:forgejo";
                      }
                      {
                        title = "Karakeep";
                        url = "https://${config.mySnippets.cute-haus.networkMap.karakeep.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.karakeep.hostName}:${toString config.mySnippets.cute-haus.networkMap.karakeep.port}/";
                        icon = "di:karakeep";
                      }
                      {
                        title = "aly.social";
                        url = "https://${config.mySnippets.cute-haus.networkMap.aly-social.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.aly-social.hostName}:${toString config.mySnippets.cute-haus.networkMap.aly-social.port}/";
                        icon = "di:bluesky";
                      }
                      {
                        title = "Uptime Kuma";
                        url = "https://${config.mySnippets.cute-haus.networkMap.uptime-kuma.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.cute-haus.networkMap.uptime-kuma.port}/";
                        icon = "di:uptime-kuma";
                      }
                      {
                        title = "Vaultwarden";
                        url = "https://${config.mySnippets.cute-haus.networkMap.vaultwarden.vHost}/";
                        check-url = "http://${config.mySnippets.cute-haus.networkMap.vaultwarden.hostName}:${toString config.mySnippets.cute-haus.networkMap.vaultwarden.port}/";
                        icon = "di:vaultwarden";
                      }
                    ];
                  }
                  {
                    type = "monitor";
                    cache = "1m";
                    title = "Private Services";

                    sites = [
                      {
                        title = "Sonarr";
                        url = "https://sonarr.${config.mySnippets.tailnet.name}/";
                        icon = "di:sonarr";
                      }
                      {
                        title = "Radarr";
                        url = "https://radarr.${config.mySnippets.tailnet.name}/";
                        icon = "di:radarr";
                      }
                      {
                        title = "Lidarr";
                        url = "https://lidarr.${config.mySnippets.tailnet.name}/";
                        icon = "di:lidarr";
                      }
                      {
                        title = "Readarr";
                        url = "https://readarr.${config.mySnippets.tailnet.name}/";
                        icon = "di:readarr";
                      }
                      {
                        title = "Prowlarr";
                        url = "https://prowlarr.${config.mySnippets.tailnet.name}/";
                        icon = "di:prowlarr";
                      }
                      {
                        title = "Bazarr";
                        url = "https://bazarr.${config.mySnippets.tailnet.name}/";
                        icon = "di:bazarr";
                      }
                      {
                        title = "Tautulli";
                        url = "https://tautulli.${config.mySnippets.tailnet.name}/";
                        icon = "di:tautulli";
                      }
                      {
                        title = "qBittorrent";
                        url = "https://qbittorrent.${config.mySnippets.tailnet.name}/";
                        icon = "di:qbittorrent";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Homebridge";
                        url = "https://homebridge.${config.mySnippets.tailnet.name}/";
                        icon = "di:homebridge";
                      }
                    ];
                  }
                  {
                    type = "split-column";
                    widgets = [
                      {
                        type = "hacker-news";
                        collapse-after = 4;
                      }
                      {
                        type = "rss";
                        title = "The Verge";
                        limit = 10;
                        collapse-after = 5;
                        cache = "12h";

                        feeds = [
                          {
                            url = "https://www.theverge.com/rss/index.xml";
                            title = "The Verge";
                            limit = 4;
                          }
                        ];
                      }
                    ];
                  }
                  {
                    collapse-after-rows = 1;
                    style = "grid-cards";
                    type = "videos";

                    channels = [
                      "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                      "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                      "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                      "UC9PBzalIcEQCsiIkq36PyUA" # Digital Foundry
                      "UCpa-Zb0ZcQjTCPP1Dx_1M8Q" # LegalEagle
                      "UCld68syR8Wi-GY_n4CaoJGA" # Brodie Robertson
                    ];
                  }
                  {
                    type = "split-column";
                    widgets = [
                      {
                        type = "rss";
                        title = "NPR";
                        limit = 10;
                        collapse-after = 5;
                        cache = "12h";

                        feeds = [
                          {
                            url = "https://feeds.npr.org/1001/rss.xml";
                            title = "NPR";
                            limit = 4;
                          }
                        ];
                      }
                      {
                        type = "lobsters";
                        collapse-after = 4;
                      }
                    ];
                  }
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        title = "Aly Raffauf";
                        links = [
                          {
                            title = "Website";
                            url = "https://aly.codes/";
                          }
                          {
                            title = "Github";
                            url = "https://github.com/alyraffauf/";
                          }
                          {
                            title = "Linkedin";
                            url = "https://www.linkedin.com/in/alyraffauf/";
                          }
                        ];
                      }
                      {
                        title = "General";
                        links = [
                          {
                            title = "Fastmail";
                            url = "https://fastmail.com/";
                          }
                          {
                            title = "YouTube";
                            url = "https://www.youtube.com/";
                          }
                          {
                            title = "Github";
                            url = "https://github.com/";
                          }
                        ];
                      }
                      {
                        title = "Social";
                        links = [
                          {
                            title = "Bluesky";
                            url = "https://bsky.app/";
                          }
                          {
                            title = "Reddit";
                            url = "https://www.reddit.com/";
                          }
                          {
                            title = "Instagram";
                            url = "https://www.instagram.com/";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];

        server.host = "0.0.0.0";
      };
    };

    karakeep = {
      enable = true;

      extraEnvironment = rec {
        DISABLE_NEW_RELEASE_CHECK = "true";
        DISABLE_SIGNUPS = "true";
        INFERENCE_CONTEXT_LENGTH = "128000";
        INFERENCE_EMBEDDING_MODEL = "nomic-embed-text";
        INFERENCE_ENABLE_AUTO_SUMMARIZATION = "true";
        INFERENCE_IMAGE_MODEL = "gemma3:4b";
        INFERENCE_JOB_TIMEOUT_SEC = "600";
        INFERENCE_LANG = "english";
        INFERENCE_TEXT_MODEL = INFERENCE_IMAGE_MODEL;
        NEXTAUTH_URL = "https://${config.mySnippets.cute-haus.networkMap.karakeep.vHost}";
        OLLAMA_BASE_URL = "https://ollama.${config.mySnippets.tailnet.name}";
        OLLAMA_KEEP_ALIVE = "5m";
        PORT = "7020";
      };
    };

    meilisearch.dumplessUpgrade = true;

    open-webui = {
      enable = true;

      environment = {
        OLLAMA_API_BASE_URL = "https://ollama.${config.mySnippets.tailnet.name}";
        # Disable authentication
        WEBUI_AUTH = "False";
      };

      host = "0.0.0.0";
      openFirewall = true;
      port = 8585;
    };

    # navidrome = {
    #   enable = true;
    #   openFirewall = true;
    # };

    # paperless = {
    #   enable = true;
    #   address = "0.0.0.0";
    #   dataDir = "/mnt/Data/paperless";

    #   settings = {
    #     PAPERLESS_ACCOUNT_ALLOW_SIGNUPS = false;

    #     PAPERLESS_CONSUMER_IGNORE_PATTERN = [
    #       ".DS_STORE/*"
    #       "desktop.ini"
    #     ];

    #     PAPERLESS_OCR_LANGUAGE = "eng";

    #     PAPERLESS_OCR_USER_ARGS = {
    #       optimize = 1;
    #       pdfa_image_compression = "lossless";
    #     };
    #   };
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
