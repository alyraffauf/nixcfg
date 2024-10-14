{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ../common.nix
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-laptop
    self.nixosModules.hw-common-laptop-intel-cpu
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  hardware.enableAllFirmware = true;
}
