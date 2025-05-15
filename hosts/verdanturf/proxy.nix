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
        "vault.${newDomain}"
        "couchdb.${newDomain}"
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

        zone=aly.social
        aly.social
        *.aly.social
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

        "vault.${newDomain}" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
            proxyWebsockets = true;
          };

          serverAliases = ["v.${newDomain}" "passwords.${oldDomain}"];
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
