{ config, pkgs, ... }:
{
    # Open TCP ports for audiobookshelf, plex-server, and transmission-server.
    networking.firewall.allowedTCPPorts = [ 13378 32400 9091 ];
    virtualisation = {
        podman = {
            enable = true;

            # Create a `docker` alias for podman, to use it as a drop-in replacement
            dockerCompat = true;

            # Required for containers under podman-compose to be able to talk to each other.
            defaultNetwork.settings.dns_enabled = true;
        };
        oci-containers = {
            backend = "podman";
        };

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
                ports = ["0.0.0.0:9091:9091"];
                image = "linuxserver/transmission:latest";
                volumes = [
                    "/mnt/Media:/Media"
                ];
            };
        };
    };
}