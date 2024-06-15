{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod"];
      kernelModules = ["amdgpu"];
    };

    kernelModules = ["kvm-amd" "amdgpu"];
  };

  hardware = {
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    enableAllFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [rocmPackages.clr.icd amdvlk];
      extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c4217c88-3101-434b-8321-58e2ac89527c";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3445-B2A0";
      fsType = "vfat";
    };

    "/mnt/Archive" = {
      device = "/dev/disk/by-uuid/f7e9e6d6-2bf6-429a-aaf0-49b55d53fc83";
      fsType = "ext4";
    };

    "/mnt/Media" = {
      device = "/dev/disk/by-uuid/d988d5ca-f9d6-4d85-aa0e-8a437b3c859a";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/26094ada-7ba4-4437-bacb-b3cdf6c3397b";
      priority = 1;
    }
  ];

  services.xserver = {
    videoDrivers = ["amdgpu"]; # Add AMDGPU driver.
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
