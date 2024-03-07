{ config, pkgs, ... }:

{
    imports = [
        ../virtualization
    ];

    # Open TCP ports for audiobookshelf, plex-server, and transmission-server.
    networking.firewall.allowedTCPPorts = [ 51413 13378 32400 9091 ];
    networking.firewall.allowedUDPPorts = [ 51413 ];

    virtualisation = {
        oci-containers.containers = {
            audiobookshelf = {
                ports = ["0.0.0.0:13378:80"];
                image = "ghcr.io/advplyr/audiobookshelf:latest";
                environment = {
                    TZ = "America/New_York";
                };
                volumes = [
                    "abs_config:/config"
                    "abs_metadata:/metadata"
                    "/mnt/Media:/Media"
                ];
            };
            plex-server = {
                ports = ["0.0.0.0:32400:32400"];
                image = "plexinc/pms-docker:public";
                environment = {
                    TZ = "America/New_York";
                };
                volumes = [
                    "plex_config:/config"
                    "plex_transcode:/transcode"
                    "/mnt/Media:/Media"
                ];
            };
            transmission-server = {
                ports = ["0.0.0.0:9091:9091" "0.0.0.0:51413:51413"];
                image = "linuxserver/transmission:latest";
                environment = {
                    TZ = "America/New_York";
                };
                volumes = [
                    "transmission_config:/config"
                    "/mnt/Media/Torrents:/watch"
                    "/mnt/Media:/Media"
                ];
            };
            nextcloud = {
                ports = ["0.0.0.0:80:80" ];
                image = "nextcloud:latest";
                environment = {
                    TZ = "America/New_York";
                };
                volumes = [
                    "nextcloud:/var/www/html"
                    "/mnt/Media/NextCloud:/var/www/html/data"
                ];
            };
        };
    };
}