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
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t440p
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [];
    };

    extraModulePackages = [];
    kernelModules = ["kvm-intel"];
  };

  powerManagement = {
    cpuFreqGovernor = "ondemand"; # Otherwise, CPU doesn't automatically clock down.
    powertop.enable = true;
  };

  nixpkgs = {
    config.packageOverrides = pkgs: {
      # Intel drivers with accelerated video playback support.
      intel-vaapi-driver =
        pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    };

    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    enableAllFirmware = true;

    opengl = {
      enable = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
  };

  networking.useDHCP = lib.mkDefault true;
}
