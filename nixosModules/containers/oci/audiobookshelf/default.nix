{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.containers.oci.audiobookshelf.enable {
    virtualisation.oci-containers.containers = {
      audiobookshelf = {
        ports = ["0.0.0.0:${toString config.ar.containers.oci.audiobookshelf.port}:80"];
        image = "ghcr.io/advplyr/audiobookshelf:latest";
        environment = {TZ = "America/New_York";};
        volumes = ["abs_config:/config" "abs_metadata:/metadata" "${config.ar.containers.oci.audiobookshelf.mediaDirectory}:/Media"];
      };
    };
  };
}
