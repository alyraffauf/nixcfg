{...}: {
  environment.variables = {
    DPAU_DRIVER = "radeonsi";
    GSK_RENDERER = "ngl";
  };

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
