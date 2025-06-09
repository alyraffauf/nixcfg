{self, ...}: {
  imports = [
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
  ];

  options.myHardware.lenovo.thinkcentre.m700.enable = self.lib.mkEnableOption "Lenovo ThinkCentre M700 hardware configuration.";

  config = {
    boot.initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "xhci_pci"
    ];

    services.fwupd.enable = true;
  };
}
