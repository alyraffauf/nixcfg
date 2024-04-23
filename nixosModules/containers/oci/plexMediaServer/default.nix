{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.containers.oci.plexMediaServer.enable =
      lib.mkEnableOption "Enable Plex Media Server.";
    alyraffauf.containers.oci.plexMediaServer.mediaDirectory = lib.mkOption {
      description = "Media directory for Plex Media Server.";
      default = "/mnt/Media";
      type = lib.types.str;
    };
    alyraffauf.containers.oci.plexMediaServer.archiveDirectory = lib.mkOption {
      description = "Archive directory for Plex Media Server.";
      default = "/mnt/Archive";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.containers.oci.plexMediaServer.enable {
    virtualisation.oci-containers.containers = {
      plexMediaServer = {
        ports = ["0.0.0.0:32400:32400"];
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
