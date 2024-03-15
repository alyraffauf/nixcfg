{ config, pkgs, ... }:

{
    # services.ddclient.enable = true;
    # services.ddclient.configFile = "/etc/ddclient/ddclient.conf";

    # Open TCP ports for audiobookshelf, plex-server, and transmission-server.
    networking.firewall.allowedTCPPorts = [ 80 443 51413 9091 ];
    networking.firewall.allowedUDPPorts = [ 51413 ];

    networking.extraHosts = ''
        127.0.0.1 music.raffauflabs.com
        127.0.0.1 podcasts.raffauflabs.com
        127.0.0.1 plex.raffauflabs.com
    '';

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
        # virtualHosts."raffauflabs.com" =  {
        #     enableACME = true;
        #     forceSSL = true;
        #     locations."/" = {
        #         proxyPass = "http://127.0.0.1:12345";
        #         proxyWebsockets = true; # needed if you need to use WebSocket
        #         extraConfig = ''
        #             # required when the target is also TLS server with multiple hosts
        #             proxy_ssl_server_name on;
        #             # required when the server wants to use HTTP Authentication
        #             proxy_pass_header Authorization;
        #         '';
        #     };
        # };
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