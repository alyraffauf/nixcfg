{self, ...}: {
  imports = [
    ../../common.nix
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
    self.nixosModules.hardware-profiles-laptop
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "sdhci_pci"
    "thunderbolt"
  ];

  home-manager = {
    sharedModules = [
      {
        services.easyeffects = {
          enable = true;
          preset = "X1.json";
        };

        xdg.configFile."easyeffects/output/X1.json".source = ./easyeffects.json;
      }
    ];
  };

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
  };
}
