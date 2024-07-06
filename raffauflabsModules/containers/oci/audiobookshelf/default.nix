{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.containers.oci.audiobookshelf;
in {
  config = lib.mkIf cfg.enable {
    networking.extraHosts = ''
      127.0.0.1 ${cfg.subDomain}.${config.raffauflabs.domain}
    '';

    services = {
      ddclient.domains = ["${cfg.subDomain}.${config.raffauflabs.domain}"];

      nginx.virtualHosts."${cfg.subDomain}.${config.raffauflabs.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";

          extraConfig = ''
            client_max_body_size 500M;
            proxy_buffering off;
            proxy_redirect                      http:// https://;
            proxy_set_header Host               $host;
            proxy_set_header X-Forwarded-Proto  $scheme;
            proxy_set_header Connection         "upgrade";
            proxy_set_header Upgrade            $http_upgrade;
            proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
          '';
        };
      };
    };

    virtualisation.oci-containers.containers = {
      audiobookshelf = {
        ports = ["0.0.0.0:${toString cfg.port}:80"];
        image = "ghcr.io/advplyr/audiobookshelf:latest";
        environment = {TZ = "America/New_York";};
        volumes = ["abs_config:/config" "abs_metadata:/metadata" "${cfg.mediaDirectory}:/Media"];
      };
    };
  };
}
