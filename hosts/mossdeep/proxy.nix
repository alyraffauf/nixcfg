{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@fastmail.com";
  };

  services = {
    caddy = {
      email = "alyraffauf@fastmail.com";

      virtualHosts = {
        "aly.codes" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost${config.services.anubis.instances.alycodes.settings.BIND}
          '';
        };

        "aly.social" = {
          extraConfig = ''
            encode gzip
            reverse_proxy localhost:${toString config.services.pds.settings.PDS_PORT}
          '';
        };

        "git.aly.codes" = {
          extraConfig = ''
            encode gzip

            @uploads method POST PUT
            handle @uploads {
              request_body { max_size 2GB }
            }

            reverse_proxy localhost${config.services.anubis.instances.forgejo.settings.BIND}
          '';
        };
      };
    };

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
  };
}
