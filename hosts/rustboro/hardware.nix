{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
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

  hardware = {
    enableAllFirmware = true;

    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  services.fwupd.enable = true;

  ar.hardware = {
    enable = true;
    cpu.intel = true;
    gpu.intel = true;
    laptop = true;
    ssd = true;
    sound = true;
  };
}
