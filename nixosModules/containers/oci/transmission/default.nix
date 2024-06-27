{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.containers.oci.transmission.enable {
    virtualisation.oci-containers.containers = {
      transmission = {
        ports = ["0.0.0.0:${toString config.ar.containers.oci.transmission.port}:9091" "0.0.0.0:${toString config.ar.containers.oci.transmission.bitTorrentPort}:51413"];
        image = "linuxserver/transmission:latest";
        environment = {
          PGID = "1000";
          PUID = "1000";
          TZ = "America/New_York";
        };
        volumes = [
          "transmission_config:/config"
          "${config.ar.containers.oci.transmission.mediaDirectory}:/Media"
          "${config.ar.containers.oci.transmission.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
