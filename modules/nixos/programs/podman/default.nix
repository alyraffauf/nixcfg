{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = lib.optionals (config.services.xserver.enable) [pkgs.pods];

    virtualisation = {
      oci-containers = {backend = "podman";};

      podman = {
        enable = true;
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };
  };
}
