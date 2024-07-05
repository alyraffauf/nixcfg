# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  input,
  lib,
  pkgs,
  self,
  ...
}: let
  acmeEmail = "alyraffauf@gmail.com";
  hostName = "mauville";
  domain = "raffauflabs.com";
  mediaDirectory = "/mnt/Media";
  archiveDirectory = "/mnt/Archive";
in {
  imports = [
    ./filesystems.nix
    ./hardware.nix
    ./home.nix
  ];

  age.secrets = {
    cloudflare.file = ../../secrets/cloudflare.age;
    nixCache.file = ../../secrets/nixCache/privKey.age;
    codebergToken.file = ../../secrets/runners/codeberg.age;
    raffauflabsToken.file = ../../secrets/runners/raffauflabs.age;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  system.stateVersion = "23.11";

  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
        config.ar.containers.oci.transmission.port
        config.ar.containers.oci.transmission.bitTorrentPort
      ];

      allowedUDPPorts = [config.ar.containers.oci.transmission.bitTorrentPort];
    };

    # My router doesn't expose settings for NAT loopback
    # So we have to use this workaround.
    extraHosts = ''
      127.0.0.1 git.${domain}
      127.0.0.1 music.${domain}
      127.0.0.1 news.${domain}
      127.0.0.1 nixcache.${domain}
      127.0.0.1 plex.${domain}
      127.0.0.1 podcasts.${domain}
    '';

    hostName = hostName;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmail;
  };

  services = {
    ddclient = {
      enable = true;
      domains = [
        "git.raffauflabs.com"
        "music.raffauflabs.com"
        "plex.raffauflabs.com"
        "podcasts.raffauflabs.com"
        "raffauflabs.com"
      ];
      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      use = "web, web=dynamicdns.park-your-domain.com/getip, web-skip='Current IP Address: '";
      username = "token";
      zone = "raffauflabs.com";
    };

    fail2ban.enable = true;

    forgejo = {
      enable = true;
      lfs.enable = true;

      settings = {
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://github.com";
        };

        cron = {
          ENABLED = true;
          RUN_AT_START = false;
        };

        DEFAULT.APP_NAME = "Git @ RaffaufLabs.com";

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
          ROOT_URL = "https://git.${domain}/";
        };

        service = {
          ALLOW_ONLY_INTERNAL_REGISTRATION = true;
          DISABLE_REGISTRATION = false;
          ENABLE_NOTIFY_MAIL = true;
        };

        session.COOKIE_SECURE = true;

        ui.DEFAULT_THEME = "forgejo-auto";
        "ui.meta" = {
          AUTHOR = "Git @ RaffaufLabs.com";
          DESCRIPTION = "Self-hosted git projects + toys.";
          KEYWORDS = "git,forge,forgejo,aly raffauf";
        };
      };
    };

    gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances = {
        "codeberg" = {
          enable = true;
          labels = [
            "ubuntu-latest:docker://node:16-bullseye"
            "ubuntu-22.04:docker://node:16-bullseye"
            "ubuntu-20.04:docker://node:16-bullseye"
            "ubuntu-18.04:docker://node:16-buster"
            "native:host"
          ];
          name = "mauville";

          tokenFile = config.age.secrets.codebergToken.path;
          url = "https://codeberg.org";
        };

        "raffauflabs" = {
          enable = true;
          labels = [
            "ubuntu-latest:docker://node:16-bullseye"
            "ubuntu-22.04:docker://node:16-bullseye"
            "ubuntu-20.04:docker://node:16-bullseye"
            "ubuntu-18.04:docker://node:16-buster"
            "native:host"
          ];
          name = "mauville";

          settings = {
            container.network = "host";
            options = "--add-host=git.raffauflabs.com:127.0.0.1";
            runner.insecure = true;
          };

          tokenFile = config.age.secrets.raffauflabsToken.path;
          url = config.services.forgejo.settings.server.ROOT_URL;
        };
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "git.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}";

            extraConfig = ''
              client_max_body_size 512M;
            '';
          };
        };

        "music.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.ar.containers.nixos.navidrome.port}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "news.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.ar.containers.oci.freshRSS.port}";
            proxyWebsockets = true; # needed if you need to use WebSocket

            extraConfig = ''
              proxy_buffering off;
              proxy_redirect off;
              # Forward the Authorization header for the Google Reader API.
              proxy_pass_header Authorization;
              proxy_set_header Authorization $http_authorization;
            '';
          };
        };

        "nixcache.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${
            toString config.services.nix-serve.port
          }";
        };

        "plex.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.ar.containers.oci.plexMediaServer.port}";
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
            proxyPass = "http://127.0.0.1:${toString config.ar.containers.oci.audiobookshelf.port}";

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

    nix-serve = {
      enable = true;
      secretKeyFile = config.age.secrets.nixCache.path;
    };

    ollama = {
      enable = true;
      acceleration = "rocm";
    };

    samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";

      shares = {
        Media = {
          browseable = "yes";
          comment = "Media @ ${hostName}";
          path = mediaDirectory;
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0755";
          "directory mask" = "0755";
        };

        Archive = {
          browseable = "yes";
          comment = "Archive @ ${hostName}";
          path = archiveDirectory;
          "create mask" = "0755";
          "directory mask" = "0755";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  ar = {
    apps = {
      firefox.enable = true;
      nicotine-plus.enable = true;
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    base = {
      enable = true;
      zramSwap.size = 100;
    };

    containers = {
      nixos.navidrome.enable = true;

      oci = {
        audiobookshelf.enable = true;
        freshRSS.enable = true;
        plexMediaServer.enable = true;
        transmission.enable = true;
      };
    };

    desktop = {
      greetd = {
        enable = true;

        autologin = {
          enable = true;
          user = "aly";
        };
      };

      hyprland.enable = true;
      steam.enable = true;
    };

    users = {
      aly = {
        enable = true;
        password = "$y$j9T$SHPShqI2IpRE101Ey2ry/0$0mhW1f9LbVY02ifhJlP9XVImge9HOpf23s9i1JFLIt9";
      };

      dustin = {
        enable = true;
        password = "$y$j9T$3mMCBnUQ.xjuPIbSof7w0.$fPtRGblPRSwRLj7TFqk1nzuNQk2oVlgvb/bE47sghl.";
      };
    };

    services = {
      syncthing = {
        enable = true;
        syncMusic = true;
        musicPath = "${mediaDirectory}/Music";
      };

      tailscale.enable = true;
    };
  };
}
