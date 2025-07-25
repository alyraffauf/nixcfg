{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.prometheusNode = {
    enable = lib.mkEnableOption "prometheus node exporter for monitoring system metrics";
  };

  config = lib.mkIf config.myNixOS.services.prometheusNode.enable {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = ["systemd"];

      extraFlags = [
        "--collector.ethtool"
        "--collector.softirqs"
        "--collector.tcpstat"
        "--collector.wifi"
      ];

      port = 3021;
    };
  };
}
