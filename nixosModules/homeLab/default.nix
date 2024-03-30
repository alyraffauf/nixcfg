{ pkgs, lib, config, ... }: {

  imports =
    [ ./binaryCache ./reverseProxy ./nixContainers ./ociContainers ./samba ];

  options = {
    homeLab.enable = lib.mkEnableOption "Enables fully functional Home Lab.";
  };

  config = lib.mkIf config.homeLab.enable {
    homeLab.binaryCache.enable = lib.mkDefault true;
    homeLab.nixContainers.enable = lib.mkDefault true;
    homeLab.ociContainers.enable = lib.mkDefault true;
    homeLab.reverseProxy.enable = lib.mkDefault true;
    homeLab.samba.enable = lib.mkDefault true;
  };
}
