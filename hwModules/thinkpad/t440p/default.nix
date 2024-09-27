{...}: {
  imports = [
    ../../common/bluetooth
    ../../common/cpu/intel
    ../../common/gpu/intel
    ../../common/laptop
    ../../common/laptop/intel-cpu.nix
    ../../common/ssd
    ../common.nix
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
}
