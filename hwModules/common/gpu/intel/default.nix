{pkgs, ...}: {
  boot.initrd.kernelModules = ["i915"];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  hardware = {
    intel-gpu-tools.enable = true;

    opengl = {
      enable = true;

      extraPackages = [
        pkgs.intel-media-driver # LIBVA_DRIVER_NAME=iHD
        (pkgs.intel-vaapi-driver.override {enableHybridCodec = true;})
        pkgs.libvdpau-va-gl
      ];

      extraPackages32 = [
        pkgs.driversi686Linux.intel-media-driver # LIBVA_DRIVER_NAME=iHD
        (pkgs.driversi686Linux.intel-vaapi-driver.override {enableHybridCodec = true;})
        pkgs.driversi686Linux.libvdpau-va-gl
      ];
    };
  };

  services.xserver.videoDrivers = ["modesetting"];
}
