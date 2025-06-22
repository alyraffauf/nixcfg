{config, ...}: {
  services = {
    grafana = {
      enable = true;

      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3010;
          domain = "grafana.narwhal-snapper.ts.net";
        };
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
          }
        ];
      };
    };

    loki = {
      enable = true;

      configuration = {
        auth_enabled = false;

        server = {
          http_listen_port = 3030;
          grpc_listen_port = 0;
        };

        common = {
          instance_addr = "127.0.0.1";
          path_prefix = "/tmp/loki";

          storage = {
            filesystem = {
              chunks_directory = "/tmp/loki/chunks";
              rules_directory = "/tmp/loki/rules";
            };
          };

          replication_factor = 1;

          ring = {
            kvstore = {
              store = "inmemory";
            };
          };
        };

        frontend = {
          max_outstanding_per_tenant = 2048;
        };

        pattern_ingester = {
          enabled = true;
        };

        limits_config = {
          max_global_streams_per_user = 0;
          ingestion_rate_mb = 50000;
          ingestion_burst_size_mb = 50000;
          volume_enabled = true;
        };

        query_range = {
          results_cache = {
            cache = {
              embedded_cache = {
                enabled = true;
                max_size_mb = 100;
              };
            };
          };
        };

        schema_config = {
          configs = [
            {
              from = "2020-10-24";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };

        analytics = {
          reporting_enabled = false;
        };
      };
    };

    prometheus = {
      enable = true;
      globalConfig.scrape_interval = "10s";
      port = 3020;

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "lavaridge:3021"
                "lilycove:3021"
                "mauville:3021"
                "mossdeep:3021"
                "slateport:3021"
                "verdanturf:3021"
              ];
            }
          ];
        }
      ];
    };
  };
}
