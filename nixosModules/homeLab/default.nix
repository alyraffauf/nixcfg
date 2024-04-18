{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./binaryCache ./reverseProxy ./nixContainers ./ociContainers ./samba];

  options = {
    alyraffauf.homeLab.enable = lib.mkEnableOption "Enables fully functional Home Lab.";
  };

  config = lib.mkIf config.alyraffauf.homeLab.enable {
    alyraffauf.homeLab.binaryCache.enable = lib.mkDefault true;
    alyraffauf.homeLab.nixContainers.enable = lib.mkDefault true;
    alyraffauf.homeLab.ociContainers.enable = lib.mkDefault true;
    alyraffauf.homeLab.reverseProxy.enable = lib.mkDefault true;
    alyraffauf.homeLab.samba.enable = lib.mkDefault true;
  };
}
