{
  description = "Aly's NixOS flake.";

  inputs = {
    # Latest Stable NixOS, tracked by FlakeHub.
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

    # Tracks latest stable home-manager using FlakeHub.
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.*.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable NixOS channel.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Unstable-small NixOS channel.
    nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # Home-manager, used for managing user configuration.
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # # Declarative Flatpaks.
    # nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";

    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  nixConfig = {
    extra-substituters = [ "https://nixcache.raffauflabs.com" ];
    extra-trusted-public-keys = [
      "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
    ];
  };

  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-unstable
    , nixpkgs-unstable-small, home-manager-unstable, nixos-hardware, ... }: {

      homeConfigurations."aly" =
        home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable { system = "x86_64-linux"; };
          modules = [ ./home/aly.nix ];
        };

      nixosConfigurations = {

        # Framework 13 with AMD Ryzen 7640U and 32GB RAM.
        lavaridge = nixpkgs-unstable-small.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            home-manager-unstable.nixosModules.home-manager
            ./hosts/lavaridge
          ];
        };

        # Home Lab. Ryzen 5 2600 with 16GB RAM, RX 6700.
        mauville = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager-unstable.nixosModules.home-manager
            ./hosts/mauville
          ];
        };

        # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
        petalburg = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            home-manager-unstable.nixosModules.home-manager
            ./hosts/petalburg
          ];
        };

        # T440p with i5-4210M and 16GB RAM.
        rustboro = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-t440p
            home-manager-unstable.nixosModules.home-manager
            ./hosts/rustboro
          ];
        };
      };
    };
}
