{
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.systemd.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = lib.mkDefault "/var/lib/sbctl";
    };

    loader.systemd-boot.enable = lib.mkForce false;
  };

  environment.systemPackages = [pkgs.sbctl];
}
