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

        zone=aly.codes
        status.aly.codes

        zone=aly.social
        status.aly.social
      '';
    };

    caddy = {
      enable = true;
      email = "alyraffauf@fastmail.com";

      virtualHosts = {
        "couchdb.${newDomain}" = {
          serverAliases = [
            "couchdb.${newDomain}"
            "couch.${oldDomain}"
          ];

          extraConfig = ''
            encode gzip
            reverse_proxy 127.0.0.1:${toString config.services.couchdb.port}
          '';
        };

        "uptime-kuma.${newDomain}" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost${config.services.anubis.instances.uptime-kuma.settings.BIND} {
              flush_interval -1   # proxy_buffering off equivalent
            }
          '';
        };

        "status.${newDomain}" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost${config.services.anubis.instances.uptime-kuma.settings.BIND} {
              flush_interval -1
            }
          '';
        };

        "status.aly.codes" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost${config.services.anubis.instances.uptime-kuma.settings.BIND} {
              flush_interval -1
            }
          '';
        };

        "status.aly.social" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost${config.services.anubis.instances.uptime-kuma.settings.BIND} {
              flush_interval -1
            }
          '';
        };

        "vault.${newDomain}" = {
          serverAliases = [
            "vault.${newDomain}"
            "v.${newDomain}"
            "passwords.${oldDomain}"
          ];

          extraConfig = ''
            encode gzip
            reverse_proxy 127.0.0.1:${
              toString config.services.vaultwarden.config.ROCKET_PORT
            }
          '';
        };
      };
    };
  };
}
