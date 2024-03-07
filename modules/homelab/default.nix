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
                volumes = [
                    "/mnt/Media:/Media"
                ];
            };
            plex-server = {
                ports = ["0.0.0.0:32400:32400"];
                image = "plexinc/pms-docker:public";
                volumes = [
                    "/mnt/Media:/Media"
                ];
            };
            transmission-server = {
                ports = ["0.0.0.0:9091:9091" "0.0.0.0:51413:51413"];
                image = "linuxserver/transmission:latest";
                volumes = [
                    "/mnt/Media:/Media"
                ];
            };
        };
    };
}