{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../common/bluetooth
    ../../../common/cpu/intel
    ../../../common/gpu/intel
    ../../../common/laptop
    ../../../common/laptop/intel-cpu.nix
    ../../../common/ssd
    ../common.nix
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  hardware.enableAllFirmware = true;
}
