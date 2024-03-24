{ pkgs, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    oci-containers = { backend = "podman"; };
    podman = {
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      enable = true;
    };
  };
}
