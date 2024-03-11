{ config, pkgs, ... }:

{
    imports = [
        ../virtualization
    ];

    # services.ddclient.enable = true;
    # services.ddclient.configFile = "/etc/ddclient/ddclient.conf";

    # Open TCP ports for audiobookshelf, plex-server, and transmission-server.
    networking.firewall.allowedTCPPorts = [ 80 443 51413 13378 32400 9091 ];
    networking.firewall.allowedUDPPorts = [ 51413 ];

    virtualisation = {
        oci-containers.containers = {
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

    containers.audiobookshelf = {
        autoStart = true;
        bindMounts = { 
            "/Media" = { hostPath = "/mnt/Media";
            isReadOnly = false; 
            };
        };
        config = { config, pkgs, lib, ... }: {
            services.audiobookshelf = {
                enable = true;
                openFirewall = true;
                port = 13378;
                host = "0.0.0.0";
            };
            system.stateVersion = "24.05";
        };
    };

    security.acme = {
        acceptTerms = true;
        defaults.email = "alyraffauf@gmail.com";
    };
    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        # other Nginx options
        virtualHosts."raffauflabs.com" =  {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://127.0.0.1:12345";
                proxyWebsockets = true; # needed if you need to use WebSocket
                extraConfig = ''
                    # required when the target is also TLS server with multiple hosts
                    proxy_ssl_server_name on;
                    # required when the server wants to use HTTP Authentication
                    proxy_pass_header Authorization;
                '';
            };
        };
        virtualHosts."podcasts.raffauflabs.com" =  {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://127.0.0.1:13378";
                # proxyWebsockets = true; # This breaks audiobookshelf.
                extraConfig = ''
                    proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
                    proxy_set_header  X-Forwarded-Proto $scheme;
                    proxy_set_header  Host              $host;
                    proxy_set_header Upgrade            $http_upgrade;
                    proxy_set_header Connection         "upgrade";
                    proxy_redirect                      http:// https://;
                    proxy_buffering off;
                '';
            };
        };
        virtualHosts."plex.raffauflabs.com" =  {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://127.0.0.1:32400";
                proxyWebsockets = true; # needed if you need to use WebSocket
                extraConfig = ''
                    proxy_buffering off;
                '';
            };
        };
        virtualHosts."music.raffauflabs.com" =  {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://127.0.0.1:4533";
                proxyWebsockets = true; # needed if you need to use WebSocket
                extraConfig = ''
                    proxy_buffering off;
                '';
            };
        };
    };
}