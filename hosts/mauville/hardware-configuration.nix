{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu"];
  boot.extraModulePackages = [ ];

  services.xserver = {
    # Add AMDGPU driver.
    videoDrivers = [ "amdgpu" ];
  };

  hardware.opengl = {
    enable = true;
    # Add ROCM annd AMD Vulkan driver.
    extraPackages = with pkgs; [ rocmPackages.clr.icd amdvlk ];
    # Add support for 32bit apps.
    driSupport32Bit = true;
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c4217c88-3101-434b-8321-58e2ac89527c";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3445-B2A0";
    fsType = "vfat";
  };

  fileSystems."/mnt/Archive" = {
    device = "/dev/disk/by-uuid/f7e9e6d6-2bf6-429a-aaf0-49b55d53fc83";
    fsType = "ext4";
  };

  fileSystems."/mnt/Media" = {
    device = "/dev/disk/by-uuid/d988d5ca-f9d6-4d85-aa0e-8a437b3c859a";
    fsType = "ext4";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/26094ada-7ba4-4437-bacb-b3cdf6c3397b";
    priority = 1;
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
