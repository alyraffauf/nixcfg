{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.containers.oci.plexMediaServer.enable {
    virtualisation.oci-containers.containers = {
      plexMediaServer = {
        ports = ["0.0.0.0:${toString config.ar.containers.oci.plexMediaServer.port}:32400"];
        image = "plexinc/pms-docker:public";
        environment = {TZ = "America/New_York";};
        volumes = [
          "plex_config:/config"
          "plex_transcode:/transcode"
          "${config.ar.containers.oci.plexMediaServer.mediaDirectory}:/Media"
          "${config.ar.containers.oci.plexMediaServer.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
