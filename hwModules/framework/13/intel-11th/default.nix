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
    ../../common.nix
    ../common.nix
  ];

  boot = {
    blacklistedKernelModules = ["cros-usbpd-charger"];
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    kernelParams = [
      "nvme.noacpi=1" # https://community.frame.work/t/linux-battery-life-tuning/6665/156
    ];
  };

  hardware.acpilight.enable = true;
}
