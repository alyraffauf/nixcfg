{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true; # Enable auto-rotate and tablet mode.
  };

  ar.hardware = {
    enable = true;
    cpu.intel = true;
    gpu.intel = true;
    laptop = true;
    ssd = true;
    sound = true;
  };
}
