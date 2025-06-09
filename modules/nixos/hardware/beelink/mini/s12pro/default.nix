{self, ...}: {
  imports = [
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
  ];

  options.myHardware.beelink.mini.s12pro.enable = self.lib.mkEnableOption "Beelink Mini S12Pro hardware configuration.";

  config = {
    boot.initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "xhci_pci"
    ];
  };
}
