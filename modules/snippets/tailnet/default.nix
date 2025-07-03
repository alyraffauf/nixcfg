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
        couchdb = {
          hostName = "verdanturf";
          port = 5984;
          vHost = "couchdb.${config.mySnippets.tailnet.name}";
        };

        grafana = {
          hostName = "mauville";
          port = 3010;
          vHost = "grafana.${config.mySnippets.tailnet.name}";
        };

        loki = {
          hostName = "mauville";
          port = 3100;
          vHost = "loki.${config.mySnippets.tailnet.name}";
        };

        prometheus = {
          hostName = "mauville";
          port = 3020;
          vHost = "prometheus.${config.mySnippets.tailnet.name}";
        };
      };
    };
  };
}
