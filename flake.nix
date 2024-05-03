{
  description = "Aly's NixOS flake.";

  inputs = {
    # Unstable NixOS channel.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager, used for managing user configuration.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = ["https://nixcache.raffauflabs.com" ];
    extra-trusted-public-keys = [
      "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
    ];
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-hardware,
    impermanence,
    disko,
    jovian,
    ...
  }: {
    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    homeConfigurations = {
      aly = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [./aly.nix];
      };
      dustin = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [./dustin.nix];
      };
    };

    nixosConfigurations = {
      # Steam Deck OLED
      mossdeep = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          jovian.nixosModules.default
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          home-manager.nixosModules.home-manager
          ./hosts/mossdeep
          ./nixosModules
        ];
      };

      # Framework 13 with AMD Ryzen 7640U and 32GB RAM.
      lavaridge = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          ./hosts/lavaridge
          ./nixosModules
        ];
      };

      # Framework 13 with 11th Gen Intel Core i5 and 16GB RAM.
      fallarbor = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager
          ./hosts/fallarbor
          ./nixosModules
        ];
      };

      # Home Lab. Ryzen 5 2600 with 16GB RAM, RX 6700.
      mauville = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          home-manager.nixosModules.home-manager
          ./hosts/mauville
          ./nixosModules
        ];
      };

      # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
      petalburg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          nixos-hardware.nixosModules.common-cpu-intel
          home-manager.nixosModules.home-manager
          ./hosts/petalburg
          ./nixosModules
        ];
      };

      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p
          home-manager.nixosModules.home-manager
          ./hosts/rustboro
          ./nixosModules
        ];
      };
    };
  };
}
