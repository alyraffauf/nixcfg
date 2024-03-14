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

  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-unstable, home-manager-unstable, nixos-hardware, ... }: {

    nixosConfigurations = {

      # Framework 13 with AMD Ryzen 7640U and 32GB RAM.
      lavaridge = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager-unstable.nixosModules.home-manager
          ./hosts/lavaridge
          ./desktop/gnome
        ];
      };
      
      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p
          home-manager-unstable.nixosModules.home-manager
          ./hosts/rustboro
          ./desktop/kde.nix
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
          ./desktop/gnome
        ];
      };

      # Ryzen 5 2600 with 16GB RAM, RX 6700.
      mauville = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager-unstable.nixosModules.home-manager
          ./hosts/mauville
          ./modules/homelab
          ./desktop/gnome
          ./modules/steam.nix
        ];
      };
    };
  };
}
