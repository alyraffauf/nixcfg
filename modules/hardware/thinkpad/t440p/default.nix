{self, ...}: {
  imports = [
    ../common.nix
    self.nixosModules.hw-common
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-laptop
    self.nixosModules.hw-common-laptop-intel-cpu
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
      options thinkpad_acpi force_load=1 fan_control=1
    '';

    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "rtsx_pci_sdmmc"
      "sd_mod"
      "sr_mod"
      "usb_storage"
      "xhci_pci"
    ];
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  services.fwupd.enable = true;
  zramSwap.algorithm = "lz4";
}
