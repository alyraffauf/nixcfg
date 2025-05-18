{config, ...}: let
  oldDomain = "raffauflabs.com";
  newDomain = "cute.haus";
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@fastmail.com";
  };

  services = {
    ddclient = {
      enable = true;

      domains = [
        "couchdb.${newDomain}"
        "status.${newDomain}"
        "uptime-kuma.${newDomain}"
        "vault.${newDomain}"
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      username = "token";
      zone = newDomain;

      extraConfig = ''
        zone=raffauflabs.com
        couch.${oldDomain}
        passwords.${oldDomain}
      '';
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "couchdb.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:5984";
          };

          serverAliases = ["couch.${oldDomain}"];
        };

        "uptime-kuma.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.uptime-kuma.settings.BIND}";
            proxyWebsockets = true;
          };
        };

        "status.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.uptime-kuma.settings.BIND}";
            proxyWebsockets = true;
          };
        };

        "vault.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
            proxyWebsockets = true;
          };

          serverAliases = ["v.${newDomain}" "passwords.${oldDomain}"];
        };
      };
    };
  };
}
