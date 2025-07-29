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
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.aly-codes.hostName}:${toString config.mySnippets.cute-haus.networkMap.aly-codes.port}
          '';
        };

        "aly.social" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.aly-social.hostName}:${toString config.mySnippets.cute-haus.networkMap.aly-social.port}
          '';
        };

        "audiobookshelf.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.audiobookshelf.hostName}:${toString config.mySnippets.cute-haus.networkMap.audiobookshelf.port} {
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
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.glance.hostName}:${toString config.mySnippets.cute-haus.networkMap.glance.port}
          '';
        };

        "${config.mySnippets.cute-haus.networkMap.forgejo.vHost}" = {
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

        "immich.cute.haus" = {
          extraConfig = ''
            encode zstd gzip

            @uploads method POST PUT
            handle @uploads {
              request_body {
                max_size 10GB
              }
            }

            reverse_proxy ${config.mySnippets.cute-haus.networkMap.immich.hostName}:${toString config.mySnippets.cute-haus.networkMap.immich.port} {
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

            reverse_proxy ${config.mySnippets.cute-haus.networkMap.karakeep.hostName}:${toString config.mySnippets.cute-haus.networkMap.karakeep.port} {
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

            reverse_proxy ${config.mySnippets.cute-haus.networkMap.ombi.hostName}:${toString config.mySnippets.cute-haus.networkMap.ombi.port} {
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}}
            }
          '';
        };

        "plex.cute.haus" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy ${config.mySnippets.cute-haus.networkMap.plex.hostName}:${toString config.mySnippets.cute-haus.networkMap.plex.port} {
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
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.cute-haus.networkMap.uptime-kuma.port}
          '';
        };

        "status.aly.social" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.cute-haus.networkMap.uptime-kuma.port}
          '';
        };

        "status.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.cute-haus.networkMap.uptime-kuma.port}
          '';
        };

        "vault.cute.haus" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${config.mySnippets.cute-haus.networkMap.vaultwarden.hostName}:${toString config.mySnippets.cute-haus.networkMap.vaultwarden.port} {
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
