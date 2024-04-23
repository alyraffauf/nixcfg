{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.containers.oci.audiobookshelf.enable =
      lib.mkEnableOption "Enable audiobookshelf podcast and audiobook server.";
    alyraffauf.containers.oci.audiobookshelf.mediaDirectory = lib.mkOption {
      description = "Media directory for audiobookshelf.";
      default = "/mnt/Media";
      type = lib.types.str;
    };
    alyraffauf.containers.oci.audiobookshelf.port = lib.mkOption {
      description = "Port for audiobookshelf.";
      default = 13378;
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.alyraffauf.containers.oci.audiobookshelf.enable {
    virtualisation.oci-containers.containers = {
      audiobookshelf = {
        ports = ["0.0.0.0:${toString config.alyraffauf.containers.oci.audiobookshelf.port}:80"];
        image = "ghcr.io/advplyr/audiobookshelf:latest";
        environment = {TZ = "America/New_York";};
        volumes = ["abs_config:/config" "abs_metadata:/metadata" "${config.alyraffauf.containers.oci.audiobookshelf.mediaDirectory}:/Media"];
      };
    };
  };
}
