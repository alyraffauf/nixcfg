{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.hw-common-amd-cpu
    self.nixosModules.hw-common-amd-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "amdgpu"
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "sdhci_pci"
        "thunderbolt"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];

      kernelModules = ["amdgpu"];
    };

    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = with config.boot.kernelPackages; [acpi_call zenpower];
    kernelModules = ["zenpower"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
  };

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true;
  };

  services.upower.enable = true;
}
