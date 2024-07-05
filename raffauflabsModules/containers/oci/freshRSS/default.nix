{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.containers.oci.freshRSS;
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
          proxyWebsockets = true; # needed if you need to use WebSocket

          extraConfig = ''
            proxy_buffering off;
            proxy_redirect off;
            # Forward the Authorization header for the Google Reader API.
            proxy_pass_header Authorization;
            proxy_set_header Authorization $http_authorization;
          '';
        };
      };
    };

    virtualisation.oci-containers.containers = {
      freshrss = {
        ports = ["0.0.0.0:${toString cfg.port}:80"];
        image = "freshrss/freshrss:latest";
        environment = {
          TZ = "America/New_York";
          CRON_MIN = "1,31";
        };
        volumes = [
          "freshrss_data:/var/www/FreshRSS/data"
          "freshrss_extensions:/var/www/FreshRSS/extensions"
        ];
      };
    };
  };
}
