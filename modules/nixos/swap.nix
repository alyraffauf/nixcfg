_: {
  flake.nixosModules.default = {
    swapDevices = [
      {
        device = "/swapfile";
        size = 8192;
        priority = 10;
      }
    ];
  };
}
