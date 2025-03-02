{config, ...}: let
  domain = "raffauflabs.com";
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@fastmail.com";
  };

  services = {
    ddclient = {
      enable = true;

      domains = [
        "couch.${domain}"
        "passwords.${domain}"
        "aly.social"
        "*.aly.social"
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      usev4 = "webv4, web=dynamicdns.park-your-domain.com/getip, web-skip='Current IP Address: '";
      username = "token";
      zone = domain;
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "couch.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:5984";
          };
        };

        "passwords.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          };
        };

        "aly.social" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.pds.settings.PDS_PORT}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
