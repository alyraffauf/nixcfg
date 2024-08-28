{config, ...}: let
  ip = "mauville";
  domain = "raffauflabs.com";
in {
  networking = {
    hosts."127.0.0.1" = ["passwords.${domain}"];
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
        "bt.${domain}"
        "git.${domain}"
        "music.${domain}"
        "passwords.${domain}"
        "plex.${domain}"
        "podcasts.${domain}"
        domain
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      use = "web, web=dynamicdns.park-your-domain.com/getip, web-skip='Current IP Address: '";
      username = "token";
      zone = domain;
    };

    fail2ban = {
      enable = true;
      bantime = "1h";
    };

    homepage-dashboard = {
      enable = true;
      openFirewall = true;

      bookmarks = [
        # {
        # Websites = [
        # {
        #   "Aly Raffauf" = [
        #     {
        #       abbr = "AR";
        #       description = "Personal website and portfolio.";
        #       href = "https://aly.raffauflabs.com/";
        #     }
        #   ];
        # }
        # ];
        # }
      ];

      services = [
        {
          Websites = [
            {
              "Aly Raffauf" = {
                abbr = "AR";
                description = "Personal website and portfolio.";
                href = "https://aly.raffauflabs.com/";
              };
            }
            {
              "Specular Anomalies" = {
                abbr = "SA";
                description = "Academic & tech blog.";
                href = "https://distort.jp/";
              };
            }
          ];
        }
        {
          Media = [
            {
              "Audiobookshelf" = {
                description = "Audiobooks & podcasts.";
                href = "https://podcasts.raffauflabs.com";
                icon = "audiobookshelf";
              };
            }
            {
              "Plex" = {
                description = "TV Shows, movies & music.";
                href = "https://plex.raffauflabs.com";
                icon = "plex";
              };
            }
            {
              "Navidrome" = {
                description = "Subsonic-compatible music streaming.";
                href = "https://music.raffauflabs.com";
                icon = "navidrome";
              };
            }
          ];
        }
        {
          Tools = [
            {
              "Forĝejo" = {
                description = "Git forge for open source projects.";
                href = "https://git.raffauflabs.com";
                icon = "forgejo";
              };
            }
            {
              "Transmission (Tailnet only)" = {
                description = "Torrent client with web UI.";
                href = "http://mauville:9091";
                icon = "transmission";
              };
            }
            {
              "Vaultwarden" = {
                description = "Secure password manager.";
                href = "https://passwords.raffauflabs.com";
                icon = "vaultwarden";
              };
            }
          ];
        }
      ];

      settings = {
        color = "sky";
        target = "_self";
        title = "RaffaufLabs.com";
      };

      widgets = [
        {
          glances = {
            url = "http:/mauville:61208/";
            cpu = true;
            mem = true;
            disk = "/mnt/Media";
          };
        }
        {
          search = {
            provider = "brave";
            showSearchSuggestions = true;
          };
        }
        {
          datetime = {
            text_size = "xl";
            format.timeStyle = "short";
          };
        }
      ];
    };

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
        "${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";

            extraConfig = ''
              client_max_body_size 512M;
            '';
          };
        };

        "git.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 3000}";

            extraConfig = ''
              client_max_body_size 512M;
            '';
          };
        };

        "music.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 4533}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "passwords.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          };
        };

        "plex.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 32400}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "podcasts.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 13378}";

            extraConfig = ''
              client_max_body_size 500M;
              proxy_buffering off;
              proxy_redirect                      http:// https://;
              proxy_set_header Host               $host;
              proxy_set_header X-Forwarded-Proto  $scheme;
              proxy_set_header Connection         "upgrade";
              proxy_set_header Upgrade            $http_upgrade;
              proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
            '';
          };
        };
      };
    };

    vaultwarden = {
      enable = true;

      config = {
        DOMAIN = "https://passwords.raffauflabs.com";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_LOG = "critical";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = false;
      };
    };
  };
}
