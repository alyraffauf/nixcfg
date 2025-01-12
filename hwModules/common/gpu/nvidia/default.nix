{...}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;

      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}
