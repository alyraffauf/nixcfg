{ config, pkgs, ... }:

{
    imports = [
        ../virtualization
    ];

    # Open TCP ports for audiobookshelf, plex-server, and transmission-server.
    networking.firewall.allowedTCPPorts = [ 51413 13378 32400 9091 4533];
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
        };
    };

    containers.navidrome = {
        autoStart = true;
        bindMounts = { 
            "/Music" = { hostPath = "/mnt/Media/Music";
            isReadOnly = true; 
            };
        };
        config = { config, pkgs, lib, ... }: {
            services.navidrome = {
                enable = true;
                openFirewall = true;
                settings = {
                    Address = "0.0.0.0";
                    Port = 4533;
                    MusicFolder = "/Music";
                    DefaultTheme = "Auto";
                    SubsonicArtistParticipations = true;
                    DefaultDownsamplingFormat = "aac";
                };
            };
            system.stateVersion = "24.05";
        };
    };
}
