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
    initrd.availableKernelModules = ["thunderbolt" "nvme" "sdhci_pci"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";

    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
