{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    audiobookshelf = {
      ports = [ "0.0.0.0:13378:80" ];
      image = "ghcr.io/advplyr/audiobookshelf:latest";
      environment = { TZ = "America/New_York"; };
      volumes =
        [ "abs_config:/config" "abs_metadata:/metadata" "/mnt/Media:/Media" ];
    };
    plex-server = {
      ports = [ "0.0.0.0:32400:32400" ];
      image = "plexinc/pms-docker:public";
      environment = { TZ = "America/New_York"; };
      volumes = [
        "plex_config:/config"
        "plex_transcode:/transcode"
        "/mnt/Media:/Media"
        "/mnt/Archive:/Archive"
      ];
    };
    transmission-server = {
      ports = [ "0.0.0.0:9091:9091" "0.0.0.0:51413:51413" ];
      image = "linuxserver/transmission:latest";
      environment = {
        PGID = "1000";
        PUID = "1000";
        TZ = "America/New_York";
      };
      volumes = [
        "transmission_config:/config"
        "/mnt/Media:/Media"
        "/mnt/Archive:/Archive"
      ];
    };
    jellyfin = {
      ports = [ "0.0.0.0:8096:8096" ];
      image = "jellyfin/jellyfin";
      environment = { TZ = "America/New_York"; };
      volumes = [
        "jellyfin_config:/config"
        "jellyfin_cache:/cache"
        "/mnt/Media:/Media"
        "/mnt/Archive:/Archive"
      ];
    };
  };
}
