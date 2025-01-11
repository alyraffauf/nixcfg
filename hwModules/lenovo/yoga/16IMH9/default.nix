{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.hw-common
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-laptop
    self.nixosModules.hw-common-laptop-intel-cpu
    self.nixosModules.hw-common-nvidia-gpu
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}
