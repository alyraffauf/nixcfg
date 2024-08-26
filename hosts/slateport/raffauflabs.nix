{config, ...}: let
  ip = "192.168.0.103";
  domain = "raffauflabs.com";
in {
  networking = {
    firewall.allowedTCPPorts = [80 443];
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

    k3s = {
      enable = true;
      clusterInit = true;
      role = "server";
      tokenFile = config.age.secrets.k3s.path;
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "bt.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "${ip}:${toString 9091}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
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
            proxyPass = "${ip}:${toString 4533}";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "plex.${domain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "${ip}:32400";
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
            proxyPass = "${ip}:${toString 13378}";

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
  };
}
