{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.raffauflabs.containers.oci.transmission.enable {
    networking.firewall = {
      allowedTCPPorts = [
        config.raffauflabs.containers.oci.transmission.port
        config.raffauflabs.containers.oci.transmission.bitTorrentPort
      ];

      allowedUDPPorts = [config.raffauflabs.containers.oci.transmission.bitTorrentPort];
    };

    virtualisation.oci-containers.containers = {
      transmission = {
        ports = ["0.0.0.0:${toString config.raffauflabs.containers.oci.transmission.port}:9091" "0.0.0.0:${toString config.raffauflabs.containers.oci.transmission.bitTorrentPort}:51413"];
        image = "linuxserver/transmission:latest";
        environment = {
          PGID = "1000";
          PUID = "1000";
          TZ = "America/New_York";
        };
        volumes = [
          "transmission_config:/config"
          "${config.raffauflabs.containers.oci.transmission.mediaDirectory}:/Media"
          "${config.raffauflabs.containers.oci.transmission.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
