{ config, pkgs, ... }:

{
    # services.ddclient.enable = true;
    # services.ddclient.configFile = "/etc/ddclient/ddclient.conf";

    # Open TCP ports for audiobookshelf, plex-server, and transmission-server.
    networking = {
        firewall = {
            allowedTCPPorts = [ 80 443 51413 9091 ];
            allowedUDPPorts = [ 51413 ];
        };
        # My router doesn't expose settings for NAT loopback
        # So we have to use this workaround.
        extraHosts = ''
            127.0.0.1 music.raffauflabs.com
            127.0.0.1 nixcache.raffauflabs.com
            127.0.0.1 plex.raffauflabs.com
            127.0.0.1 podcasts.raffauflabs.com
        '';
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

        virtualHosts."nixcache.raffauflabs.com" = {
            enableACME = true;
            forceSSL = true;
            locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
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
                    client_max_body_size 500M;
                '';
            };
        };
    };
}