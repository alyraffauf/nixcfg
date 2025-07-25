{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./equalizer.nix
  ];

  options.myHardware.framework.laptop13.amd-7000.enable = lib.mkEnableOption "Framework Laptop 13 AMD 7000 hardware configuration.";

  config = lib.mkIf config.myHardware.framework.laptop13.amd-7000.enable {
    boot = {
      initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];

      extraModprobeConfig = ''
        options snd_hda_intel power_save=1
      '';

      kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);
    };

    networking.networkmanager = {
      enable = true;

      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    myHardware = {
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles = {
        base.enable = true;
        laptop.enable = true;
      };
    };
  };
}
