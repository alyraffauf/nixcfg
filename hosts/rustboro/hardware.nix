{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
      options thinkpad_acpi force_load=1 fan_control=1
    '';

    initrd = {
      availableKernelModules = ["ahci" "ehci_pci" "i915" "rtsx_pci_sdmmc" "sd_mod" "sr_mod" "usb_storage" "xhci_pci"];
      kernelModules = ["i915"];
    };

    kernelModules = ["i915" "kvm-intel"];
  };

  powerManagement = {
    cpuFreqGovernor = "ondemand"; # Otherwise, CPU doesn't automatically clock down.
    powertop.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;

    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };

    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
  };
}
