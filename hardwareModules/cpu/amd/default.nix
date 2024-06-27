{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.cpu.amd {
    boot = {
      kernelModules = ["kvm-amd"];
      kernelParams =
        lib.optional (config.ar.hardware.laptop) "amd_pstate=active";
    };

    hardware = {
      cpu.amd.updateMicrocode = true;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
