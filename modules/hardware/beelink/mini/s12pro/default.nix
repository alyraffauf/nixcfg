{self, ...}: {
  imports = [
    self.nixosModules.hw-common
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-ssd
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "xhci_pci"
  ];
}
