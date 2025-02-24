{self, ...}: {
  imports = [
    ../common.nix
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
    self.nixosModules.hardware-profiles-laptop
  ];

  config = {
    boot.initrd.availableKernelModules = [
      "nvme"
      "thunderbolt"
    ];

    services = {
      fprintd.enable = true;
      fwupd.enable = true;
      # throttled.enable = true;
    };
  };
}
