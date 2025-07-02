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
            reverse_proxy localhost${config.services.anubis.instances.alycodes.settings.BIND}
          '';
        };

        "aly.social" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy mossdeep:3000
          '';
        };

        "audiobookshelf.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy mauville:13378 {
              flush_interval -1   # proxy_buffering off
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}
            }
          '';
        };

        "cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy slateport:8080
          '';
        };

        "immich.cute.haus" = {
          extraConfig = ''
            encode zstd gzip

            @uploads method POST PUT
            handle @uploads {
              request_body {
                max_size 10GB
              }
            }

            reverse_proxy lilycove:2283 {
              flush_interval -1
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}

              transport http {
                read_buffer 0
              }
            }
          '';
        };

        "karakeep.cute.haus" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy mauville:7020 {
              flush_interval -1
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}
            }
          '';
        };

        "ombi.cute.haus" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy lilycove:5000 {
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}
            }
          '';
        };

        "plex.cute.haus" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy lilycove:32400 {
              flush_interval -1   # proxy_buffering off equivalent
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

        "status.aly.codes" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy verdanturf:3001 {
              flush_interval -1   # proxy_buffering off equivalent
            }
          '';
        };

        "status.aly.social" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy verdanturf:3001 {
              flush_interval -1   # proxy_buffering off equivalent
            }
          '';
        };

        "status.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy verdanturf:3001 {
              flush_interval -1   # proxy_buffering off equivalent
            }
          '';
        };

        "uptime-kuma.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy verdanturf:3001 {
              flush_interval -1   # proxy_buffering off equivalent
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}
            }
          '';
        };

        "vault.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy verdanturf:8222 {
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}
            }
          '';
        };
      };
    };
  };
}
