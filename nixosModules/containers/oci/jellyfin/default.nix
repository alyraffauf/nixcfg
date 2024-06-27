{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.containers.oci.jellyfin.enable {
    virtualisation.oci-containers.containers = {
      jellyfin = {
        ports = ["0.0.0.0:${toString config.ar.containers.oci.jellyfin.port}:8096"];
        image = "jellyfin/jellyfin";
        environment = {TZ = "America/New_York";};
        volumes = [
          "jellyfin_config:/config"
          "jellyfin_cache:/cache"
          "${config.ar.containers.oci.jellyfin.mediaDirectory}:/Media"
          "${config.ar.containers.oci.jellyfin.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
