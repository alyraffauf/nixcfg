{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    blacklistedKernelModules = ["cros-usbpd-charger"];

    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];

    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
      kernelModules = ["i915"];
    };

    kernelModules = [
      # https://github.com/DHowett/framework-laptop-kmod?tab=readme-ov-file#usage
      "cros_ec_lpcs"
      "cros_ec"
      "i915"
      "kvm-intel"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "nvme.noacpi=1" # https://community.frame.work/t/linux-battery-life-tuning/6665/156
    ];
  };

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
      VDPAU_DRIVER = "va_gl";
    };

    systemPackages = [pkgs.framework-tool] ++ lib.optional (pkgs ? "fw-ectool") pkgs.fw-ectool;
  };

  hardware = {
    acpilight.enable = true;
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

    sensor.iio.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Save power/better manage heat & fans.
  powerManagement.powertop.enable = true;

  services = {
    fprintd.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    thermald.enable = true;

    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
    '';
  };
}
