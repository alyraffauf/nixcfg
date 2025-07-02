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
      '';
    };

    caddy = {
      email = "alyraffauf@fastmail.com";

      virtualHosts = {
        "couchdb.${newDomain}" = {
          serverAliases = [
            "couchdb.${newDomain}"
            "couch.${oldDomain}"
          ];

          extraConfig = ''
            encode zstd gzip
            reverse_proxy 127.0.0.1:${toString config.services.couchdb.port}
          '';
        };
      };
    };
  };
}
