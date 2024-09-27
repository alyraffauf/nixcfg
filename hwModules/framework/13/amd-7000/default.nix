{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../common/bluetooth
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/laptop
    ../../../common/laptop/amd-gpu.nix
    ../../../common/ssd
    ../../common.nix
    ../common.nix
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
    '';
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    wifi.backend = "iwd";
  };
}
