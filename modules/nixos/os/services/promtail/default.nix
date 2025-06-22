{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.promtail = {
    enable = lib.mkEnableOption "promtail for tailing logs";

    lokiUrl = lib.mkOption {
      description = "Loki URL to report to";
      default = "https://loki.narwhal-snapper.ts.net/loki/api/v1/push";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.promtail.enable {
    services.promtail = {
      enable = true;

      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };

        positions = {
          filename = "/tmp/positions.yaml";
        };

        clients = [
          {
            url = config.myNixOS.services.promtail.lokiUrl;
          }
        ];

        scrape_configs = [
          {
            job_name = "journal";

            journal = {
              max_age = "12h";

              labels = {
                job = "systemd-journal";
                host = config.networking.hostName;
              };
            };

            relabel_configs = [
              {
                source_labels = ["__journal__systemd_unit"];
                target_label = "unit";
              }
              {
                source_labels = ["__journal__systemd_user_unit"];
                target_label = "user_unit";
              }
            ];
          }
        ];
      };
    };
  };
}
