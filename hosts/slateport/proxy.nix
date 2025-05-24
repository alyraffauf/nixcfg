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

        "immich.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.immich.settings.BIND}";
            proxyWebsockets = true;

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
