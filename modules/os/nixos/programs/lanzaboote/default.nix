{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.programs.lanzaboote.enable = lib.mkEnableOption "secure boot with lanzaboote";

  config = lib.mkIf config.myNixOS.programs.lanzaboote.enable {
    boot = {
      initrd.systemd.enable = true;

      lanzaboote = {
        enable = true;
        pkiBundle = lib.mkDefault "/var/lib/sbctl";
      };

      loader.systemd-boot.enable = lib.mkForce false;
    };

    environment.systemPackages = [pkgs.sbctl];
  };
}
