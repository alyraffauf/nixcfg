{config, ...}: let
  ip = "mauville";
  newDomain = "cute.haus";
in {
  networking = {
    firewall.allowedTCPPorts = [80 443 2222 2379 2380 6443 8581];
    firewall.allowedUDPPorts = [8472];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@gmail.com";
  };

  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      streamConfig = ''
        upstream ssh_forgejo {
          # point at your Forgejo SSH listener on mauville
          server mauville:2222;
        }

        server {
          listen       2222;         # slateport's port 2222
          proxy_pass   ssh_forgejo; # hand off to upstream
          # (optional) proxy_protocol on;  # if you need X-Forwarded-For support
        }
      '';

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
              proxy_read_timeout 600s;
              proxy_redirect off;
              proxy_request_buffering off;
              proxy_send_timeout 600s;
              send_timeout 600s;
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
      };
    };
  };
}
