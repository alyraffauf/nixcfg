{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ../../common.nix
    ../common.nix
    self.nixosModules.hw-common
    self.nixosModules.hw-intel-cpu
    self.nixosModules.hw-intel-gpu
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
