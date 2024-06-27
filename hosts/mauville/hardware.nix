{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod"];

  hardware.enableAllFirmware = true;

  ar.hardware = {
    enable = true;
    cpu.amd = true;
    gpu.amd = true;
    laptop = false;
    ssd = true;
    sound = true;
  };
}
