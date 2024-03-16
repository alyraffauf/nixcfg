{ config, pkgs, ... }:

{
    imports = [
        ./virtualization.nix
        ./nginx_proxy.nix
        ./samba.nix
    ];

    # services.ddclient.enable = true;
    # services.ddclient.configFile = "/etc/ddclient/ddclient.conf";

    # Open TCP ports for transmission-server.
    networking.firewall.allowedTCPPorts = [ 51413 9091 ];
    networking.firewall.allowedUDPPorts = [ 51413 ];

    virtualisation.oci-containers.containers = {
        audiobookshelf = {
            ports = ["0.0.0.0:13378:80"];
            image = "ghcr.io/advplyr/audiobookshelf:latest";
            environment = { TZ = "America/New_York"; };
            volumes = [
                "abs_config:/config"
                "abs_metadata:/metadata"
                "/mnt/Media:/Media"
            ];
        };
        plex-server = {
            ports = ["0.0.0.0:32400:32400"];
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
            ports = ["0.0.0.0:9091:9091" "0.0.0.0:51413:51413"];
            image = "linuxserver/transmission:latest";
            environment = { TZ = "America/New_York"; };
            volumes = [
                "transmission_config:/config"
                "/mnt/Media:/Media"
                "/mnt/Archive:/Archive"
            ];
        };
        jellyfin = {
            ports = ["0.0.0.0:8096:8096"];
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

    containers.navidrome = {
        autoStart = true;
        bindMounts."/Music".hostPath = "/mnt/Media/Music";
        config = { config, pkgs, lib, ... }: {
            system.stateVersion = "24.05";
            services.navidrome = {
                enable = true;
                openFirewall = true;
                settings = {
                    Address = "0.0.0.0";
                    Port = 4533;
                    MusicFolder = "/Music";
                    DefaultTheme = "Auto";
                    SubsonicArtistParticipations = true;
                    UIWelcomeMessage = "Welcome to Navidrome on Raffauf Labs.";
                };
            };
        };
    };
}
