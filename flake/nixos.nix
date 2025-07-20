{
  self,
  inputs,
  ...
}: {
  flake = {
    diskoConfigurations = {
      btrfs-subvolumes = ../modules/nixos/disko/btrfs-subvolumes;
      luks-btrfs-subvolumes = ../modules/nixos/disko/luks-btrfs-subvolumes;
      lvm-ext4 = ../modules/nixos/disko/lvm-ext4;
    };

    nixosModules = {
      hardware = ../modules/nixos/hardware;
      locale-en-us = ../modules/nixos/locale/en-us;
      nixos = ../modules/nixos/os;
      snippets = ../modules/snippets;
      users = ../modules/nixos/users;
    };

    nixosConfigurations = let
      modules = self.nixosModules;
    in
      inputs.nixpkgs.lib.genAttrs [
        "dewford"
        "evergrande"
        "fallarbor"
        "lavaridge"
        "lilycove"
        "littleroot"
        "mauville"
        "mossdeep"
        "oldale"
        "petalburg"
        "rustboro"
        "slateport"
        "sootopolis"
        "verdanturf"
      ] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ../hosts/${host}
              inputs.agenix.nixosModules.default
              inputs.chaotic.homeManagerModules.default
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.stylix.nixosModules.stylix
              inputs.vscode-server.nixosModules.default
              modules.hardware
              modules.nixos
              modules.snippets
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
                    self.inputs.nur.overlays.default
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
