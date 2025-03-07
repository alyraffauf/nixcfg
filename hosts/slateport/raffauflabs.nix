{config, ...}: let
  ip = "mauville";
  oldDomain = "raffauflabs.com";
  newDomain = "cute.haus";
in {
  networking = {
    firewall.allowedTCPPorts = [80 443 2379 2380 6443];
    firewall.allowedUDPPorts = [8472];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@gmail.com";
  };

  services = {
    ddclient = {
      enable = true;

      domains = [
        "audiobookshelf.${newDomain}"
        "immich.${newDomain}"
        "navidrome.${newDomain}"
        "plex.${newDomain}"
        newDomain
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      username = "token";
      zone = newDomain;

      extraConfig = ''
        zone=raffauflabs.com
        ${oldDomain}
        music.${oldDomain}
        pics.${oldDomain}
        plex.${oldDomain}
        podcasts.${oldDomain}
      '';
    };

    fail2ban = {
      enable = true;
      bantime = "24h";
      bantime-increment.enable = true;
    };

    # homepage-dashboard = {
    #   enable = true;
    #   environmentFile = config.age.secrets.homepage.path;
    #   openFirewall = true;

    #   bookmarks = [
    #     # {
    #     # Websites = [
    #     # {
    #     #   "Aly Raffauf" = [
    #     #     {
    #     #       abbr = "AR";
    #     #       description = "Personal website and portfolio.";
    #     #       href = "https://aly.codes";
    #     #     }
    #     #   ];
    #     # }
    #     # ];
    #     # }
    #   ];

    #   services = [
    #     {
    #       Websites = [
    #         {
    #           "Aly Raffauf" = {
    #             abbr = "AR";
    #             description = "Personal website and portfolio.";
    #             href = "https://aly.codes/";
    #           };
    #         }
    #         {
    #           "Specular Anomalies" = {
    #             abbr = "SA";
    #             description = "Academic & tech blog.";
    #             href = "https://distort.jp/";
    #           };
    #         }
    #       ];
    #     }
    #     {
    #       Media = [
    #         {
    #           "Audiobookshelf" = {
    #             description = "Audiobooks & podcasts.";
    #             href = "https://audiobookshelf.cute.haus";
    #             icon = "audiobookshelf";
    #             widget = {
    #               type = "audiobookshelf";
    #               url = "http://mauville:13378";
    #               key = "{{HOMEPAGE_VAR_ABS}}";
    #             };
    #           };
    #         }
    #         {
    #           "Plex" = {
    #             description = "TV Shows, movies & music.";
    #             href = "https://plex.cute.haus";
    #             icon = "plex";
    #           };
    #         }
    #         {
    #           "Navidrome" = {
    #             description = "Subsonic-compatible music streaming.";
    #             href = "https://navidrome.cute.haus";
    #             icon = "navidrome";
    #           };
    #         }
    #       ];
    #     }
    #     {
    #       Tools = [
    #         {
    #           "Forĝejo" = {
    #             description = "Git forge for open source projects.";
    #             href = "https://git.cute.haus";
    #             icon = "forgejo";
    #           };
    #         }
    #         {
    #           "Transmission (Tailnet only)" = {
    #             description = "Torrent client with web UI.";
    #             href = "http://mauville:9091";
    #             icon = "transmission";
    #             widget = {
    #               type = "transmission";
    #               url = "http://mauville:9091";
    #               username = "transmission";
    #               password = "{{HOMEPAGE_VAR_TRANSMISSION}}";
    #               rpcUrl = "/transmission/";
    #             };
    #           };
    #         }
    #         {
    #           "Vaultwarden" = {
    #             description = "Secure password manager.";
    #             href = "https://vault.cute.haus";
    #             icon = "vaultwarden";
    #           };
    #         }
    #       ];
    #     }
    #   ];

    #   settings = {
    #     color = "sky";
    #     target = "_self";
    #     title = "RaffaufLabs.com";
    #   };

    #   widgets = [
    #     {
    #       glances = {
    #         url = "http:/mauville:61208/";
    #         cpu = true;
    #         mem = true;
    #         disk = "/mnt/Media";
    #       };
    #     }
    #     {
    #       search = {
    #         provider = "brave";
    #         showSearchSuggestions = true;
    #       };
    #     }
    #     {
    #       datetime = {
    #         text_size = "xl";
    #         format.timeStyle = "short";
    #       };
    #     }
    #   ];
    # };

    # k3s = {
    #   enable = true;
    #   clusterInit = true;
    #   role = "server";
    #   tokenFile = config.age.secrets.k3s.path;
    # };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "${oldDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";

            extraConfig = ''
              client_max_body_size 512M;
            '';
          };
        };

        # "git.${oldDomain}" = {
        #   enableACME = true;
        #   forceSSL = true;

        #   locations."/" = {
        #     proxyPass = "http://${ip}:${toString 3000}";

        #     extraConfig = ''
        #       client_max_body_size 512M;
        #     '';
        #   };
        # };

        "navidrome.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 4533}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };

          serverAliases = ["n.${newDomain}" "music.${oldDomain}"];
        };

        "immich.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 2283}";

            extraConfig = ''
              client_max_body_size 5000M;
              proxy_buffering off;
              proxy_redirect                      http:// https://;
              proxy_set_header Host               $host;
              proxy_set_header X-Forwarded-Proto  $scheme;
              proxy_set_header Connection         "upgrade";
              proxy_set_header Upgrade            $http_upgrade;
              proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
            '';
          };

          serverAliases = ["i.${newDomain}" "pics.${oldDomain}"];
        };

        "plex.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 32400}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };

          serverAliases = ["p.${newDomain}" "plex.${oldDomain}"];
        };

        "audiobookshelf.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 13378}";
            proxyWebsockets = true;

            extraConfig = ''
              client_max_body_size 500M;
              proxy_buffering off;
              proxy_redirect                      http:// https://;
              proxy_set_header Host               $host;
              proxy_set_header X-Forwarded-Proto  $scheme;
              proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
            '';
          };

          serverAliases = ["a.${newDomain}" "podcasts.${oldDomain}"];
        };
      };
    };
  };
}
