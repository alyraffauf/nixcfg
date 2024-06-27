{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci"];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware.enableAllFirmware = true;

  ar.hardware = {
    cpu.amd = true;
    gpu.amd = true;
    laptop = false;
    ssd = true;
  };
}
