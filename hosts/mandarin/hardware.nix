{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixhw.nixosModules.common-amd-cpu
    inputs.nixhw.nixosModules.common-amd-gpu
    inputs.nixhw.nixosModules.common-bluetooth
    inputs.nixhw.nixosModules.common-ssd
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci"];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware.enableAllFirmware = true;
}
