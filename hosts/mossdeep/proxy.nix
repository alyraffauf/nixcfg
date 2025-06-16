{
  config,
  pkgs,
  self,
  ...
}: {
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
            encode gzip zstd
            reverse_proxy localhost:${toString config.myNixOS.services.alycodes.port}
          '';
        };

        "aly.social" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy localhost:${toString config.services.pds.settings.PDS_PORT}
          '';
        };

        "git.aly.codes" = {
          extraConfig = ''
            encode zstd gzip

            @uploads method POST PUT
            handle @uploads {
              request_body { max_size 2GB }
            }

            reverse_proxy localhost${config.services.anubis.instances.forgejo.settings.BIND} {
              header_up X-Real-Ip {remote_host}
            }
          '';
        };

        "self2025.aly.codes" = {
          extraConfig = let
            site = self.inputs.self2025.packages.${pkgs.system}.default;
          in ''
            encode zstd gzip
            file_server
            root * ${site}
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
