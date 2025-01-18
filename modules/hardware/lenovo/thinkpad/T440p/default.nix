{self, ...}: {
  imports = [
    ../common.nix
    self.nixosModules.hw-common
    self.nixosModules.hw-intel-cpu
    self.nixosModules.hw-intel-gpu
    self.nixosModules.hw-profiles-laptop
  ];

  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
      options thinkpad_acpi force_load=1 fan_control=1
    '';

    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "rtsx_pci_sdmmc"
      "sd_mod"
      "sr_mod"
      "usb_storage"
      "xhci_pci"
    ];
  };

  home-manager = {
    sharedModules = [
      {
        services.easyeffects = {
          enable = true;
          preset = "T440p.json";
        };

        xdg.configFile."easyeffects/output/T440p.json".source = ./easyeffects.json;
      }
    ];
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  services.fwupd.enable = true;
  zramSwap.algorithm = "lz4";
}
