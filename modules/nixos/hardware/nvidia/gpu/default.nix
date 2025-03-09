{config, ...}: {
  config = {
    boot = {
      extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
      initrd.kernelModules = ["nvidia"];
      kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = false;
        powerManagement.enable = true;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
