{...}: {
  environment.variables.VDPAU_DRIVER = "radeonsi";

  hardware = {
    amdgpu = {
      initrd.enable = true;

      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };

      opencl.enable = true;
    };

    graphics.enable = true;
  };
}
