{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "alyraffauf@fastmail.com";
  };

  services = {
    caddy = {
      email = "alyraffauf@fastmail.com";

      virtualHosts = {
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
      };
    };
  };
}
