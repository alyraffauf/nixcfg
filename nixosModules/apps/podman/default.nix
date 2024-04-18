{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.podman.enable =
      lib.mkEnableOption "Enables Podman for OCI container support.";
  };

  config = lib.mkIf config.alyraffauf.apps.podman.enable {
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
