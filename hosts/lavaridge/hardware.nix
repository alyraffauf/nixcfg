{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];

    initrd = {
      availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
      kernelModules = ["amdgpu"];
    };

    kernelModules = ["amdgpu" "cros_ec" "cros_ec_lpcs" "kvm-amd"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["amdgpu.abmlevel=0" "amd_pstate=active"];
  };

  environment.systemPackages = [pkgs.framework-tool];

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableAllFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [pkgs.rocmPackages.clr.icd pkgs.amdvlk];
      extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    };

    sensor.iio.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services = {
    fprintd.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;

    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
    '';
  };
}
