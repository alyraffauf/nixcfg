{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.gpu.amd {
    boot = {
      initrd.kernelModules = ["amdgpu"];

      kernelModules = ["amdgpu"];
      # Disable AMD Backlight Management.
      # ABM severely degrades display quality for miniscule power efficiency gains.
      kernelParams = ["amdgpu.abmlevel=0"];
    };

    hardware.amdgpu = {
      initrd.enable = true;

      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };

      opencl.enable = true;
    };
  };
}
