{
  config,
  self,
  ...
}: let
  ip = "mauville";
  oldDomain = "raffauflabs.com";
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
        "immich.${newDomain}"
        "navidrome.${newDomain}"
        "ombi.${newDomain}"
        "plex.${newDomain}"
        "uptime-kuma.${newDomain}"
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
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;
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
            proxyPass = "http://localhost:${toString config.services.glance.settings.server.port}";

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

        "ombi.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${ip}:${toString 5000}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };
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

        "uptime-kuma.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://roxanne:${toString 3001}";

            extraConfig = ''
              client_max_body_size 512M;
            '';
          };
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
