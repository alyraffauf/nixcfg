{
  config,
  self,
  ...
}: {
  imports = [
    self.inputs.tailscale-golink.nixosModules.default
  ];

  services = {
    ddclient = {
      enable = true;

      domains = [
        "audiobookshelf.cute.haus"
        "forgejo.cute.haus"
        "immich.cute.haus"
        "lidarr.cute.haus"
        "navidrome.cute.haus"
        "ombi.cute.haus"
        "plex.cute.haus"
        "prowlarr.cute.haus"
        "radarr.cute.haus"
        "sonarr.cute.haus"
        "cute.haus"
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      username = "token";
      zone = "cute.haus";
    };

    glance = {
      enable = true;
      openFirewall = true;

      settings = {
        pages = [
          {
            name = "cute.haus";
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
                        url = "https://plex.cute.haus/";
                        check-url = "http://lilycove:32400/web/index.html";
                        icon = "di:plex";
                      }
                      {
                        title = "Ombi";
                        url = "https://ombi.cute.haus/";
                        check-url = "http://lilycove:5000";
                        icon = "di:ombi";
                      }
                      {
                        title = "Audiobookshelf";
                        url = "https://audiobookshelf.cute.haus/";
                        check-url = "http://mauville:13378";
                        icon = "di:audiobookshelf";
                      }
                      {
                        title = "Immich";
                        url = "https://immich.cute.haus/";
                        check-url = "http://lilycove:2283";
                        icon = "di:immich";
                      }
                      {
                        title = "Forĝejo";
                        url = "https://forgejo.cute.haus/";
                        check-url = "http://mauville:3000";
                        icon = "di:forgejo";
                      }
                      {
                        title = "Nextcloud";
                        url = "https://forgejo.cute.haus/";
                        check-url = "http://mauville:3000";
                        icon = "di:nextcloud";
                      }
                      {
                        title = "aly.social";
                        url = "https://aly.social/";
                        check-url = "http://mossdeep:3000/";
                        icon = "di:bluesky";
                      }
                      {
                        title = "Uptime Kuma";
                        url = "https://uptime-kuma.cute.haus/";
                        icon = "di:uptime-kuma";
                      }
                      {
                        title = "Vaultwarden";
                        url = "https://vault.cute.haus/";
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
                        url = "http://lilycove:8989/";
                        icon = "di:sonarr";
                      }
                      {
                        title = "Radarr";
                        url = "http://lilycove:7878/";
                        icon = "di:radarr";
                      }
                      {
                        title = "Lidarr";
                        url = "http://lilycove:8686/";
                        icon = "di:lidarr";
                      }
                      {
                        title = "Readarr";
                        url = "http://lilycove:8787/";
                        icon = "di:readarr";
                      }
                      {
                        title = "Prowlarr";
                        url = "http://lilycove:9696/";
                        icon = "di:prowlarr";
                      }
                      {
                        title = "Bazarr";
                        url = "http://lilycove:6767/";
                        icon = "di:bazarr";
                      }
                      {
                        title = "Tautulli";
                        url = "http://lilycove:8181/";
                        icon = "di:tautulli";
                      }
                      {
                        title = "qBittorrent";
                        url = "http://lilycove:8080";
                        icon = "di:qbittorrent";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Homebridge";
                        url = "http://slateport:8581/";
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

    golink = {
      enable = true;
      tailscaleAuthKeyFile = config.age.secrets.tailscaleAuthKey.path;
    };
  };
}
