{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.containers.oci.freshRSS.enable {
    virtualisation.oci-containers.containers = {
      freshrss = {
        ports = ["0.0.0.0:${toString config.ar.containers.oci.freshRSS.port}:80"];
        image = "freshrss/freshrss:latest";
        environment = {
          TZ = "America/New_York";
          CRON_MIN = "1,31";
        };
        volumes = [
          "freshrss_data:/var/www/FreshRSS/data"
          "freshrss_extensions:/var/www/FreshRSS/extensions"
        ];
      };
    };
  };
}
