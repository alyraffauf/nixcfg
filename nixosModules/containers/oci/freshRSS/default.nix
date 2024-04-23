{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.containers.oci.freshRSS.enable =
      lib.mkEnableOption "Enable FreshRSS news client.";
  };

  config = lib.mkIf config.alyraffauf.containers.oci.freshRSS.enable {
    virtualisation.oci-containers.containers = {
      freshrss = {
        ports = ["0.0.0.0:8080:80"];
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
