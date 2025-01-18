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

  services.udev.extraRules = ''
    ## Framework 13 -- Fix headphone noise when on powersave
    ## https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';
}
