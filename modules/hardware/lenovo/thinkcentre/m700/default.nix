{self, ...}: {
  imports = [
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "xhci_pci"
  ];

  services.fwupd.enable = true;
}
