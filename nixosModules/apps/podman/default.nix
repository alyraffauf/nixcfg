{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.apps.podman.enable {
    virtualisation = {
      oci-containers = {backend = "podman";};
      podman = {
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
        enable = true;
        autoPrune.enable = true;
      };
    };
  };
}
