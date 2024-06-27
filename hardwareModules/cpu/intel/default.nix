{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.cpu.intel {
    boot.kernelModules = ["kvm-intel"];
    hardware.cpu.intel.updateMicrocode = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.powertop.enable = config.ar.hardware.laptop;
    services.thermald.enable = config.ar.hardware.laptop;
  };
}
