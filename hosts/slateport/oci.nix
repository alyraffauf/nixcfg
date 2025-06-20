_: {
  systemd.tmpfiles.rules = ["d /var/lib/homebridge 0755 root root"];

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      homebridge = {
        environment = {
          "HOMEBRIDGE_CONFIG_UI_PORT" = "8581";
          "TZ" = "America/New_York";
        };

        extraOptions = [
          "--dns=1.1.1.1,1.0.0.1" # Tailscale workaround
          "--log-opt=max-file=1"
          "--log-opt=max-size=10mb"
          "--network=host"
        ];

        image = "homebridge/homebridge:latest";
        log-driver = "journald";
        pull = "newer";
        volumes = ["/var/lib/homebridge:/homebridge:rw"];
      };
    };
  };
}
