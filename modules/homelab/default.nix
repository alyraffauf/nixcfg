{ config, pkgs, ... }:

{
  imports = [
    ./binary_cache.nix
    ./nginx_proxy.nix
    ./nix_containers.nix
    ./oci_containers.nix
    ./samba.nix
    ./virtualization.nix
  ];

  # services.ddclient.enable = true;
  # services.ddclient.configFile = "/etc/ddclient/ddclient.conf";
}
