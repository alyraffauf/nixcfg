{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.hw-common
    self.nixosModules.hw-common-amd-cpu
    self.nixosModules.hw-common-amd-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-laptop
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = ["amdgpu.dcdebugmask=0x200"];
  };

  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];

  networking.networkmanager = {
    enable = true;

    wifi = {
      backend = "iwd";
      powersave = true;
    };
  };

  programs.rog-control-center.enable = true;

  services = {
    asusd.enable = true;
    supergfxd.enable = true;
  };
}
