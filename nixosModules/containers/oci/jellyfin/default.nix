{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.containers.oci.jellyfin.enable {
    virtualisation.oci-containers.containers = {
      jellyfin = {
        ports = ["0.0.0.0:${toString config.alyraffauf.containers.oci.jellyfin.port}:8096"];
        image = "jellyfin/jellyfin";
        environment = {TZ = "America/New_York";};
        volumes = [
          "jellyfin_config:/config"
          "jellyfin_cache:/cache"
          "${config.alyraffauf.containers.oci.jellyfin.mediaDirectory}:/Media"
          "${config.alyraffauf.containers.oci.jellyfin.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
