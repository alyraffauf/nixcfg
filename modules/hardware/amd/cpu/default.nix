{
  config,
  lib,
  ...
}: {
  config = {
    boot = {
      blacklistedKernelModules = ["k10temp"]; # Conflicts with zenpower
      extraModulePackages = with config.boot.kernelPackages; [zenpower];

      kernelModules = [
        "kvm-amd"
        "zenpower" # Improved temperature monitoring
      ];
    };

    hardware.cpu.amd.updateMicrocode = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
