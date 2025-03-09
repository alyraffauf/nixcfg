{self, ...}: {
  imports = [
    ../../common.nix
    # ./equalizer.nix
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
    self.nixosModules.hardware-profiles-laptop
  ];

  config = {
    boot.initrd.availableKernelModules = [
      "nvme"
      "thunderbolt"
    ];

    home-manager = {
      sharedModules = [
        {
          services.easyeffects = {
            enable = true;
            preset = "X1C.json";
          };

          xdg.configFile."easyeffects/output/X1C.json".source = ./easyeffects.json;
        }
      ];
    };

    services = {
      fprintd.enable = true;
      fwupd.enable = true;
    };
  };
}
