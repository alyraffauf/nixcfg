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
      availableKernelModules = ["nvme" "sdhci_pci" "thunderbolt" "usb_storage" "usbhid" "xhci_pci"];
      kernelModules = ["amdgpu"];
    };

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
  };

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true;
  };

  services.upower.enable = true;
}
