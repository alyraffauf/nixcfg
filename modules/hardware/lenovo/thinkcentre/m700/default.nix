{
  config,
  lib,
  ...
}: {
  options.myHardware.lenovo.thinkcentre.m700.enable = lib.mkEnableOption "Lenovo ThinkCentre M700 hardware configuration.";

  config = lib.mkIf config.myHardware.lenovo.thinkcentre.m700.enable {
    boot.initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "xhci_pci"
    ];

    services.fwupd.enable = true;

    myHardware = {
      intel = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles.base.enable = true;
    };
  };
}
