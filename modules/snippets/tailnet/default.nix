{
  config,
  lib,
  ...
}: {
  options.mySnippets.tailnet = {
    name = lib.mkOption {
      default = "narwhal-snapper.ts.net";
      description = "Tailnet name.";
      type = lib.types.str;
    };

    networkMap = lib.mkOption {
      type = lib.types.attrs;
      description = "Hostnames, ports, and vHosts for ${config.mySnippets.tailnet.name} services.";

      default = {
        bazarr = {
          hostName = "lilycove";
          port = 6767;
          vHost = "bazarr.${config.mySnippets.tailnet.name}";
        };

        couchdb = {
          hostName = "dewford";
          port = 5984;
          vHost = "couchdb.${config.mySnippets.tailnet.name}";
        };

        jellyfin = {
          hostName = "lilycove";
          port = 8096;
          vHost = "jellyfin.${config.mySnippets.tailnet.name}";
        };

        grafana = {
          hostName = "mauville";
          port = 3010;
          vHost = "grafana.${config.mySnippets.tailnet.name}";
        };

        lidarr = {
          hostName = "lilycove";
          port = 8686;
          vHost = "lidarr.${config.mySnippets.tailnet.name}";
        };

        loki = {
          hostName = "mauville";
          port = 3030;
          vHost = "loki.${config.mySnippets.tailnet.name}";
        };

        ollama = {
          hostName = "lilycove";
          port = 11434;
          vHost = "ollama.${config.mySnippets.tailnet.name}";
        };

        prometheus = {
          hostName = "mauville";
          port = 3020;
          vHost = "prometheus.${config.mySnippets.tailnet.name}";
        };

        prowlarr = {
          hostName = "lilycove";
          port = 9696;
          vHost = "prowlarr.${config.mySnippets.tailnet.name}";
        };

        qbittorrent = {
          hostName = "lilycove";
          port = 8080;
          vHost = "qbittorrent.${config.mySnippets.tailnet.name}";
        };

        radarr = {
          hostName = "lilycove";
          port = 7878;
          vHost = "radarr.${config.mySnippets.tailnet.name}";
        };

        sonarr = {
          hostName = "lilycove";
          port = 8989;
          vHost = "sonarr.${config.mySnippets.tailnet.name}";
        };

        tautulli = {
          hostName = "lilycove";
          port = 8181;
          vHost = "tautulli.${config.mySnippets.tailnet.name}";
        };

        uptime-kuma = {
          hostName = "dewford";
          port = 3001;
          vHost = "uptime-kuma.${config.mySnippets.tailnet.name}";
        };

        vscode = {
          hostName = "lilycove";
          port = 3020;
          vHost = "vscode.${config.mySnippets.tailnet.name}";
        };
      };
    };
  };
}
