{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.raffauflabs.containers.oci.plexMediaServer.enable {
    networking.extraHosts = ''
      127.0.0.1 ${config.raffauflabs.containers.oci.plexMediaServer.subDomain}.${config.raffauflabs.domain}
    '';

    services = {
      ddclient.domains = ["${config.raffauflabs.containers.oci.plexMediaServer.subDomain}.${config.raffauflabs.domain}"];

      nginx.virtualHosts."${config.raffauflabs.containers.oci.plexMediaServer.subDomain}.${config.raffauflabs.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.raffauflabs.containers.oci.plexMediaServer.port}";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };

    virtualisation.oci-containers.containers = {
      plexMediaServer = {
        ports = ["0.0.0.0:${toString config.raffauflabs.containers.oci.plexMediaServer.port}:32400"];
        image = "plexinc/pms-docker:public";
        environment = {TZ = "America/New_York";};
        volumes = [
          "plex_config:/config"
          "plex_transcode:/transcode"
          "${config.raffauflabs.containers.oci.plexMediaServer.mediaDirectory}:/Media"
          "${config.raffauflabs.containers.oci.plexMediaServer.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
