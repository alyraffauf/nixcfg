{
  description = "Aly's NixOS flake.";

  inputs = {
    # Latest stable NixOS release.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Stable home-manager, synced with latest stable nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable NixOS.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # # Unstable version of home-manager.
    # home-manager-unstable = {
    #   url = "github:nix-community/home-manager/master";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence.url = "github:nix-community/impermanence";

    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = ["https://nixcache.raffauflabs.com"];
    extra-trusted-public-keys = [
      "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
    ];
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixos-hardware,
    disko,
    jovian,
    ...
  }: {
    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    homeConfigurations = {
      aly = home-manager.lib.homeManagerConfiguration rec {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [./aly.nix];
        extraSpecialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
      };
      dustin = home-manager.lib.homeManagerConfiguration rec {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [./dustin.nix];
        extraSpecialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
      };
    };

    nixosConfigurations = {
      # Steam Deck OLED
      mossdeep = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
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
      lavaridge = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          ./hosts/lavaridge
          ./nixosModules
        ];
      };

      # Framework 13 with 11th Gen Intel Core i5 and 16GB RAM.
      fallarbor = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager
          ./hosts/fallarbor
          ./nixosModules
        ];
      };

      # Home Lab. Ryzen 5 2600 with 16GB RAM, RX 6700.
      mauville = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-amd
          home-manager.nixosModules.home-manager
          ./hosts/mauville
          ./nixosModules
        ];
      };

      # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
      petalburg = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
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
      rustboro = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          disko.nixosModules.disko
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
