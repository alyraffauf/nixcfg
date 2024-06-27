{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    blacklistedKernelModules = ["cros-usbpd-charger"];

    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];

    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];

    kernelModules = [
      # https://github.com/DHowett/framework-laptop-kmod?tab=readme-ov-file#usage
      "cros_ec_lpcs"
      "cros_ec"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "nvme.noacpi=1" # https://community.frame.work/t/linux-battery-life-tuning/6665/156
    ];
  };

  environment.systemPackages = [pkgs.framework-tool] ++ lib.optional (pkgs ? "fw-ectool") pkgs.fw-ectool;

  hardware = {
    acpilight.enable = true;
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
    enable = true;
    cpu.intel = true;
    gpu.intel = true;
    laptop = true;
    ssd = true;
    sound = true;
  };
}
