{self, ...}: {
  imports = [
    self.nixosModules.hw-common
    self.nixosModules.hw-intel-cpu
    self.nixosModules.hw-intel-gpu
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "xhci_pci"
  ];

  services.fwupd.enable = true;
}
