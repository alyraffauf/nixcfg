{config, ...}: {
  services = {
    caddy.virtualHosts = {
      "homebridge.narwhal-snapper.ts.net" = {
        extraConfig = ''
          bind tailscale/homebridge
          encode zstd gzip
          reverse_proxy localhost:${toString config.myNixOS.services.homebridge.port}
        '';
      };
    };

    # ddclient = {
    #   enable = true;

    #   domains = [
    #     "audiobookshelf.cute.haus"
    #     "cute.haus"
    #     "forgejo.cute.haus"
    #     "immich.cute.haus"
    #     "karakeep.cute.haus"
    #     "navidrome.cute.haus"
    #     "ombi.cute.haus"
    #     "plex.cute.haus"
    #   ];

    #   interval = "10min";
    #   passwordFile = config.age.secrets.cloudflare.path;
    #   protocol = "cloudflare";
    #   ssl = true;
    #   username = "token";
    #   zone = "cute.haus";
    # };

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
                        url = "https://sonarr.${config.mySnippets.tailnet}/";
                        icon = "di:sonarr";
                      }
                      {
                        title = "Radarr";
                        url = "https://radarr.${config.mySnippets.tailnet}/";
                        icon = "di:radarr";
                      }
                      {
                        title = "Lidarr";
                        url = "https://lidarr.${config.mySnippets.tailnet}/";
                        icon = "di:lidarr";
                      }
                      {
                        title = "Readarr";
                        url = "https://readarr.${config.mySnippets.tailnet}/";
                        icon = "di:readarr";
                      }
                      {
                        title = "Prowlarr";
                        url = "https://prowlarr.${config.mySnippets.tailnet}/";
                        icon = "di:prowlarr";
                      }
                      {
                        title = "Bazarr";
                        url = "https://bazarr.${config.mySnippets.tailnet}/";
                        icon = "di:bazarr";
                      }
                      {
                        title = "Tautulli";
                        url = "https://tautulli.${config.mySnippets.tailnet}/";
                        icon = "di:tautulli";
                      }
                      {
                        title = "qBittorrent";
                        url = "https://qbittorrent.${config.mySnippets.tailnet}/";
                        icon = "di:qbittorrent";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Homebridge";
                        url = "https://homebridge.${config.mySnippets.tailnet}/";
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
  };
}
