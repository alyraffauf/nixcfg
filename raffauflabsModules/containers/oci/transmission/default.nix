{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.raffauflabs.containers.oci.transmission;
in {
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        cfg.port
        cfg.bitTorrentPort
      ];

      allowedUDPPorts = [cfg.bitTorrentPort];
    };

    virtualisation.oci-containers.containers = {
      transmission = {
        ports = ["0.0.0.0:${toString cfg.port}:9091" "0.0.0.0:${toString cfg.bitTorrentPort}:51413"];
        image = "linuxserver/transmission:latest";
        environment = {
          PGID = "1000";
          PUID = "1000";
          TZ = "America/New_York";
        };
        volumes = [
          "transmission_config:/config"
          "${cfg.mediaDirectory}:/Media"
          "${cfg.archiveDirectory}:/Archive"
        ];
      };
    };
  };
}
