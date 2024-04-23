{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.containers.oci.jellyfin.enable =
      lib.mkEnableOption "Enable Jellyfin media server.";
    alyraffauf.containers.oci.jellyfin.mediaDirectory = lib.mkOption {
      description = "Media directory for Jellyfin.";
      default = "/mnt/Media";
      type = lib.types.str;
    };
    alyraffauf.containers.oci.jellyfin.archiveDirectory = lib.mkOption {
      description = "Archive directory for Jellyfin.";
      default = "/mnt/Archive";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.containers.oci.jellyfin.enable {
    virtualisation.oci-containers.containers = {
      jellyfin = {
        ports = ["0.0.0.0:8096:8096"];
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
