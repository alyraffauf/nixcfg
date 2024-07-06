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

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod"];

  hardware.enableAllFirmware = true;
}
