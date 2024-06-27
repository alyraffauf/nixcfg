{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];

    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];

    kernelModules = ["cros_ec" "cros_ec_lpcs"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = [pkgs.framework-tool];

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true;
  };

  services = {
    fprintd.enable = true;
    fwupd.enable = true;

    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
    '';
  };

  ar.hardware = {
    cpu.amd = true;
    gpu.amd = true;
    laptop = true;
    ssd = true;
  };
}
