{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.containers.oci.plexMediaServer;
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
          proxyWebsockets = true;

          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };

    virtualisation.oci-containers.containers = {
      plexMediaServer = {
        ports = ["0.0.0.0:${toString cfg.port}:32400"];
        image = "plexinc/pms-docker:public";
        environment = {TZ = "America/New_York";};
        volumes = [
          "plex_config:/config"
          "plex_transcode:/transcode"
          "${cfg.mediaDirectory}:/Media"
          "${cfg.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
