{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@fastmail.com";
  };

  services = {
    ddclient = {
      enable = true;

      domains = [
        "aly.social"
        "*.aly.social"
      ];

      interval = "10min";
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
      ssl = true;
      username = "token";
      zone = "aly.social";

      extraConfig = ''
        zone=aly.codes
        aly.codes
      '';
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "aly.codes" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost${toString config.services.anubis.instances.alycodes.settings.BIND}";
            proxyWebsockets = true;
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
