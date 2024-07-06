{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.hardware.gpu.intel {
    boot.initrd.kernelModules = ["i915"];

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };

    hardware = {
      enableAllFirmware = true;
      intel-gpu-tools.enable = true;

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          (intel-vaapi-driver.override {enableHybridCodec = true;})
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs.driversi686Linux; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          (intel-vaapi-driver.override {enableHybridCodec = true;})
          libvdpau-va-gl
        ];
      };
    };

    services.xserver.videoDrivers = ["modesetting"];
  };
}
