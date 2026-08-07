{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.intel.gpu = {
    enable = lib.mkEnableOption "Intel GPU configuration.";

    driver = lib.mkOption {
      description = "Intel GPU driver to use";

      type = lib.types.enum [
        "i915"
        "xe"
      ];

      default = "i915";
    };
  };

  config = lib.mkIf config.myHardware.intel.gpu.enable {
    boot.initrd.kernelModules = [config.myHardware.intel.gpu.driver];

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };

    hardware = {
      intel-gpu-tools.enable = true;

      graphics = {
        enable = true;

        extraPackages = [
          (pkgs.intel-vaapi-driver.override {enableHybridCodec = true;})
          pkgs.intel-compute-runtime
          pkgs.intel-media-driver
          pkgs.intel-ocl
          pkgs.libvdpau-va-gl
          pkgs.vpl-gpu-rt
        ];

        extraPackages32 = [
          pkgs.driversi686Linux.intel-media-driver
          (pkgs.driversi686Linux.intel-vaapi-driver.override {enableHybridCodec = true;})
          pkgs.driversi686Linux.libvdpau-va-gl
        ];
      };
    };

    services.xserver.videoDrivers = ["modesetting"];
  };
}
