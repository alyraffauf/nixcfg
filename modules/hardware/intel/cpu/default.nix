{
  config,
  lib,
  ...
}: {
  options.myHardware.intel.cpu.enable = lib.mkEnableOption "Intel CPU configuration.";

  config = lib.mkIf config.myHardware.intel.cpu.enable {
    boot.kernelModules = ["kvm-intel"];
    hardware.cpu.intel.updateMicrocode = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
