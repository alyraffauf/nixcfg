{ config, pkgs, ... }:

{
    imports = [
        ./nginx_proxy.nix
        ./oci_containers.nix
        ./samba.nix
        ./virtualization.nix
        ./nix_containers.nix
    ];

    # services.ddclient.enable = true;
    # services.ddclient.configFile = "/etc/ddclient/ddclient.conf";
}
