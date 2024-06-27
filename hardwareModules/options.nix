{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  options.ar.hardware = {
    cpu = {
      amd = lib.mkEnableOption "AMD CPU support.";
      intel = lib.mkEnableOption "Intel CPU support.";
    };
    gpu = {
      amd = lib.mkEnableOption "AMD GPU support.";
      intel = lib.mkEnableOption "Intel GPU support.";
    };
    laptop = lib.mkEnableOption "Laptop optimizations.";
    ssd = lib.mkEnableOption "SSD optimizations.";
  };
}
