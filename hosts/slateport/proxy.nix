{config, ...}: let
  ip = "mauville";
  newDomain = "cute.haus";
in {
  networking = {
    firewall.allowedTCPPorts = [80 443 2222 2379 2380 6443 8581];
    firewall.allowedUDPPorts = [8472];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@gmail.com";
  };

  services.caddy = {
    email = "alyraffauf@gmail.com";

    virtualHosts = {
      "${newDomain}" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy localhost${toString config.services.anubis.instances.glance.settings.BIND}
        '';
      };

      "audiobookshelf.${newDomain}" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy localhost${toString config.services.anubis.instances.audiobookshelf.settings.BIND} {
            flush_interval -1   # proxy_buffering off
          }
        '';
      };

      "immich.${newDomain}" = {
        extraConfig = ''
          encode zstd gzip

          @uploads method POST PUT
          handle @uploads {
            request_body {
              max_size 10GB
            }
          }

          reverse_proxy localhost${toString config.services.anubis.instances.immich.settings.BIND} {
            flush_interval -1
            transport http {
              read_buffer 0     # proxy_request_buffering off
            }
          }
        '';
      };

      "karakeep.${newDomain}" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy localhost${toString config.services.anubis.instances.karekeep.settings.BIND}
        '';
      };

      "navidrome.${newDomain}" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${ip}:4533 {
            flush_interval -1
          }
        '';
      };

      "ombi.${newDomain}" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy localhost${toString config.services.anubis.instances.ombi.settings.BIND}
        '';
      };

      "plex.${newDomain}" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy localhost${toString config.services.anubis.instances.plex.settings.BIND}
        '';
      };
    };
  };
}
