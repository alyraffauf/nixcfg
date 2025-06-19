{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.framework.laptop13.intel-11th.enable = lib.mkEnableOption "Framework Laptop 13 Intel 11th gen hardware configuration.";

  config = lib.mkIf config.myHardware.framework.laptop13.intel-11th.enable {
    boot = {
      blacklistedKernelModules = ["cros-usbpd-charger"];
      initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
      kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);

      kernelParams = [
        "nvme.noacpi=1" # https://community.frame.work/t/linux-battery-life-tuning/6665/156
      ];
    };

    hardware.acpilight.enable = true;

    home-manager.sharedModules = [
      {
        services.easyeffects = {
          enable = true;
          preset = "fw13-11thgen.json";
        };

        xdg.configFile."easyeffects/output/fw13-11thgen.json".source = ./easyeffects.json;
      }
    ];

    powerManagement.powertop.enable = lib.mkForce false;

    services.udev.extraRules = ''
      ## Framework 13 -- Fix headphone noise when on powersave
      ## https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
      SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
    '';

    myHardware = {
      intel = {
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
