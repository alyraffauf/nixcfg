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
    inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

    extraModulePackages = [];
    kernelModules = ["kvm-intel"];
  };

  # Intel drivers with accelerated video playback support.
  nixpkgs = {
    config.packageOverrides = pkgs: {
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

  # Save power/better manage heat & fans.
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  networking.useDHCP = lib.mkDefault true;
}
