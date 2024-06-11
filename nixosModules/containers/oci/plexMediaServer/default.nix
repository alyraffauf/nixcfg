{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.containers.oci.plexMediaServer.enable {
    virtualisation.oci-containers.containers = {
      plexMediaServer = {
        ports = ["0.0.0.0:${toString config.alyraffauf.containers.oci.plexMediaServer.port}:32400"];
        image = "plexinc/pms-docker:public";
        environment = {TZ = "America/New_York";};
        volumes = [
          "plex_config:/config"
          "plex_transcode:/transcode"
          "${config.alyraffauf.containers.oci.plexMediaServer.mediaDirectory}:/Media"
          "${config.alyraffauf.containers.oci.plexMediaServer.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
