{
  self,
  inputs,
  ...
}: {
  flake = {
    diskoConfigurations = {
      btrfs-subvolumes = ../disko/btrfs-subvolumes;
      luks-btrfs-subvolumes = ../disko/luks-btrfs-subvolumes;
      lvm-ext4 = ../disko/lvm-ext4;
    };

    nixosModules = {
      hardware = ../hardware;
      locale-en-us = ../locale/en-us;
      nixos = ../nixos;
      users = ../users;
    };

    nixosConfigurations = let
      modules = self.nixosModules;
    in
      inputs.nixpkgs.lib.genAttrs [
        "fallarbor"
        "littleroot"
        "rustboro"
      ] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ../../hosts/${host}
              inputs.sops-nix.nixosModules.sops
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.snippets.nixosModules.snippets
              modules.hardware
              modules.nixos
              modules.users

              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit self;};
                  backupFileExtension = "backup";
                };

                nixpkgs = {
                  overlays = [
                    self.overlays.default
                  ];

                  config.allowUnfree = true;
                };
              }
            ];

            specialArgs = {inherit self;};
          }
      );
  };
}
