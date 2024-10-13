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
    initrd.availableKernelModules = ["nvme" "sdhci_pci" "thunderbolt" "usb_storage" "usbhid" "xhci_pci"];
    extraModulePackages = with config.boot.kernelPackages; [lenovo-legion-module];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };
}
