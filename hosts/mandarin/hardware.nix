{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci"];
      kernelModules = ["amdgpu"];
    };

    kernelModules = ["kvm-amd" "amdgpu"];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableAllFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [rocmPackages.clr.icd amdvlk];
      extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.fstrim.enable = true;
}
