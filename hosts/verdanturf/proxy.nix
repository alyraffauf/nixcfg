{config, ...}: {
  services = {
    # ddclient = {
    #   enable = true;

    #   domains = [
    #     "couchdb.${newDomain}"
    #   ];

    #   interval = "10min";
    #   passwordFile = config.age.secrets.cloudflare.path;
    #   protocol = "cloudflare";
    #   ssl = true;
    #   username = "token";
    #   zone = newDomain;

    #   extraConfig = ''
    #     zone=raffauflabs.com
    #     couch.${oldDomain}
    #   '';
    # };

    caddy = {
      email = "alyraffauf@fastmail.com";

      virtualHosts = {
        "${config.mySnippets.tailnet.networkMap.couchdb.vHost}" = {
          extraConfig = ''
            bind tailscale/couchdb
            encode zstd gzip
            reverse_proxy ${config.mySnippets.tailnet.networkMap.couchdb.hostName}:${toString config.mySnippets.tailnet.networkMap.couchdb.port}
          '';
        };

        "${config.mySnippets.tailnet.networkMap.grafana.vHost}" = {
          extraConfig = ''
            bind tailscale/grafana
            encode zstd gzip
            reverse_proxy ${config.mySnippets.tailnet.networkMap.grafana.hostName}:${toString config.mySnippets.tailnet.networkMap.grafana.port}
          '';
        };

        "${config.mySnippets.tailnet.networkMap.loki.vHost}" = {
          extraConfig = ''
            bind tailscale/loki
            encode zstd gzip
            reverse_proxy ${config.mySnippets.tailnet.networkMap.loki.hostName}:${toString config.mySnippets.tailnet.networkMap.loki.port}
          '';
        };

        "${config.mySnippets.tailnet.networkMap.prometheus.vHost}" = {
          extraConfig = ''
            bind tailscale/prometheus
            encode zstd gzip
            reverse_proxy ${config.mySnippets.tailnet.networkMap.prometheus.hostName}:${toString config.mySnippets.tailnet.networkMap.prometheus.port}
          '';
        };
      };
    };
  };
}
