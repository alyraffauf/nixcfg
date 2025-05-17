{
  config,
  self,
  ...
}: let
  ip = "mauville";
  newDomain = "cute.haus";
in {
  imports = [
    self.inputs.tailscale-golink.nixosModules.default
  ];

  networking = {
    firewall.allowedTCPPorts = [80 443 2379 2380 6443 8581];
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
        "forgejo.${newDomain}"
        "immich.${newDomain}"
        "lidarr.${newDomain}"
        "navidrome.${newDomain}"
        "ombi.${newDomain}"
        "plex.${newDomain}"
        "prowlarr.${newDomain}"
        "radarr.${newDomain}"
        "sonarr.${newDomain}"
        "uptime-kuma.${newDomain}"
        newDomain
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      username = "token";
      zone = newDomain;

      # extraConfig = ''
      #   zone=raffauflabs.com
      #   ${oldDomain}
      #   music.${oldDomain}
      #   pics.${oldDomain}
      #   plex.${oldDomain}
      #   podcasts.${oldDomain}
      # '';
    };

    fail2ban = {
      enable = true;
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;

      jails = {
        # HTTP basic-auth failures, 5 tries → 1-day ban
        nginx-http-auth = {
          settings = {
            enabled = true;
            maxretry = 5;
            findtime = 300;
            bantime = "24h";
          };
        };

        # Generic scanner / bot patterns (wp-login.php, sqladmin, etc.)
        nginx-botsearch = {
          settings = {
            enabled = true;
            maxretry = 10;
            findtime = 300;
            bantime = "24h";
          };
        };
      };
    };

    golink = {
      enable = true;
      tailscaleAuthKeyFile = config.age.secrets.tailscaleAuthKey.path;
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.glance.settings.BIND}";
            proxyWebsockets = true;
          };
        };

        "audiobookshelf.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.audiobookshelf.settings.BIND}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "forgejo.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.forgejo.settings.BIND}";
            proxyWebsockets = true;

            extraConfig = ''
              client_max_body_size 2G;
            '';
          };
        };

        "immich.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.immich.settings.BIND}";

            extraConfig = ''
              client_max_body_size 10G;
              proxy_buffering off;
              proxy_request_buffering off;
            '';
          };
        };

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
        };

        "ombi.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.ombi.settings.BIND}";
            proxyWebsockets = true;
          };
        };

        "plex.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.plex.settings.BIND}";
            proxyWebsockets = true;
          };
        };

        "uptime-kuma.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.uptime-kuma.settings.BIND}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = ["d /var/lib/homebridge 0755 root root"];

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      homebridge = {
        environment = {
          "HOMEBRIDGE_CONFIG_UI_PORT" = "8581";
          "TZ" = "America/New_York";
        };

        extraOptions = [
          "--dns=1.1.1.1,1.0.0.1" # Tailscale workaround
          "--log-opt=max-file=1"
          "--log-opt=max-size=10mb"
          "--network=host"
        ];

        image = "homebridge/homebridge:latest";
        log-driver = "journald";
        pull = "newer";
        volumes = ["/var/lib/homebridge:/homebridge:rw"];
      };
    };
  };
}
