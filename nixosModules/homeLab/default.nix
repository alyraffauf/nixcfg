{ pkgs, lib, config, ... }: {

  imports = [
    ./binaryCache
    ./reverseProxy
    ./nixContainers
    ./ociContainers
    ./samba
    ./virtualization
  ];

  options = {
    homeLab.enable = 
      lib.mkEnableOption "Enables fully functional HomeLab.";
  };

  config = lib.mkIf config.homeLab.enable {
    homeLab.binaryCache.enable = lib.mkDefault true;
    homeLab.nixContainers.enable = lib.mkDefault true;
    homeLab.ociContainers.enable = lib.mkDefault true;
    homeLab.reverseProxy.enable = lib.mkDefault true;
    homeLab.samba.enable = lib.mkDefault true;
    homeLab.virtualization.enable = lib.mkDefault true;
  };
}