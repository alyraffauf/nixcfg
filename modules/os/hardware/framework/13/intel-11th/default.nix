{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ../../common.nix
    ../common.nix
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
  ];

  config = {
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

    services.udev.extraRules = ''
      ## Framework 13 -- Fix headphone noise when on powersave
      ## https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
      SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
    '';
  };
}
