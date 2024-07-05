{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.raffauflabs.containers.oci.freshRSS.enable {
    networking.extraHosts = ''
      127.0.0.1 ${config.raffauflabs.containers.oci.freshRSS.subDomain}.${config.raffauflabs.domain}
    '';

    services = {
      ddclient.domains = ["${config.raffauflabs.containers.oci.freshRSS.subDomain}.${config.raffauflabs.domain}"];

      nginx.virtualHosts."${config.raffauflabs.containers.oci.freshRSS.subDomain}.${config.raffauflabs.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.raffauflabs.containers.oci.freshRSS.port}";
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
        ports = ["0.0.0.0:${toString config.raffauflabs.containers.oci.freshRSS.port}:80"];
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
