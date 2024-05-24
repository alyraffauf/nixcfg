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
  }: let
    system = "x86_64-linux";
    nixosModules = [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit inputs unstable;};
        home-manager.sharedModules = [{imports = [./homeManagerModules];}];
        home-manager.backupFileExtension = "backup";
      }
      ./nixosModules
    ];
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    specialArgs = {inherit inputs unstable;};
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = {
      # Steam Deck OLED
      mossdeep = nixpkgs.lib.nixosSystem rec {
        inherit system specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/mossdeep
            jovian.nixosModules.default
            nixos-hardware.nixosModules.common-pc-laptop-ssd
          ];
      };

      # Framework 13 with AMD Ryzen 7640U and 32GB RAM.
      lavaridge = nixpkgs.lib.nixosSystem rec {
        inherit system specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/lavaridge
            nixos-hardware.nixosModules.framework-13-7040-amd
          ];
      };

      # Framework 13 with 11th Gen Intel Core i5 and 16GB RAM.
      fallarbor = nixpkgs.lib.nixosSystem rec {
        inherit system specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/fallarbor
            nixos-hardware.nixosModules.framework-11th-gen-intel
          ];
      };

      # Home Lab. Ryzen 5 2600 with 16GB RAM, RX 6700.
      mauville = nixpkgs.lib.nixosSystem rec {
        inherit system specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/mauville
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
          ];
      };

      # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
      petalburg = nixpkgs.lib.nixosSystem rec {
        inherit system specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/petalburg
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc-laptop-ssd
          ];
      };

      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs.lib.nixosSystem rec {
        inherit system specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/rustboro
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.lenovo-thinkpad-t440p
          ];
      };
    };
  };
}
