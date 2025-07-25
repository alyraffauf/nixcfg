{
  config,
  lib,
  ...
}: {
  options.myHardware.beelink.mini.s12pro.enable = lib.mkEnableOption "Beelink Mini S12Pro hardware configuration.";

  config = lib.mkIf config.myHardware.beelink.mini.s12pro.enable {
    boot.initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "xhci_pci"
    ];

    myHardware = {
      intel = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles.base.enable = true;
    };
  };
}
