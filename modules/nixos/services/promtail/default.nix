{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.promtail = {
    enable = lib.mkEnableOption "log forwarding to Loki via Grafana Alloy";

    lokiUrl = lib.mkOption {
      description = "Loki URL to report to";
      default = "https://loki.narwhal-snapper.ts.net/loki/api/v1/push";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.promtail.enable {
    services.alloy = {
      enable = true;

      configPath = builtins.toFile "alloy-config.alloy" ''
        loki.write "default" {
          endpoint {
            url = "${config.myNixOS.services.promtail.lokiUrl}"
          }
        }

        loki.relabel "journal" {
          forward_to = []

          rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
          }

          rule {
            source_labels = ["__journal__systemd_user_unit"]
            target_label  = "user_unit"
          }
        }

        loki.source.journal "journal" {
          forward_to    = [loki.write.default.receiver]
          max_age       = "12h"
          relabel_rules = loki.relabel.journal.rules

          labels = {
            job  = "systemd-journal",
            host = "${config.networking.hostName}",
          }
        }
      '';
    };
  };
}
