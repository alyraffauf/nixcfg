{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.homebridge = {
    enable = lib.mkEnableOption "homebridge oci container";

    port = lib.mkOption {
      description = "Port to listen on.";
      default = 8581;
      type = lib.types.int;
    };

    stateDir = lib.mkOption {
      description = "Directory to store state in.";
      default = "/var/lib/homebridge";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.homebridge.enable {
    systemd.tmpfiles.rules = ["d ${config.myNixOS.services.homebridge.stateDir} 0755 root root"];

    virtualisation.oci-containers = {
      backend = "podman";

      containers = {
        homebridge = {
          environment = {
            "HOMEBRIDGE_CONFIG_UI_PORT" = toString config.myNixOS.services.homebridge.port;
            "TZ" = "America/New_York";
          };

          extraOptions =
            [
              "--log-opt=max-file=1"
              "--log-opt=max-size=10mb"
              "--network=host"
            ]
            ++ lib.optional (config.myNixOS.services.tailscale.enable) "--dns=1.1.1.1,1.0.0.1"; # Tailscale workaround;

          image = "homebridge/homebridge:latest";
          log-driver = "journald";
          pull = "newer";
          volumes = ["${config.myNixOS.services.homebridge.stateDir}:/homebridge:rw"];
        };
      };
    };

    myNixOS.programs.podman.enable = true;
  };
}
