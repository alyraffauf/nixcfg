{
  description = "Aly's NixOS configuration.";

  inputs = {
    # Unstable NixOS channel.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Release NixOS channel.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Declarative Flatpaks.
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";

    # Home-manager, used for managing user configuration.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
      # Home-manager, used for managing user configuration.
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    
    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, nix-flatpak, home-manager, home-manager-stable, nixos-hardware, ... }: {

    nixosConfigurations = {
      
      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/rustboro
          ./system
          ./users/aly
          ./desktop/gnome
          ./modules/podman
          ./modules/steam
          ./modules/via-qmk

          # Add managed flatpak module.
          nix-flatpak.nixosModules.nix-flatpak

          # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly;
          }

          # nixos-hardware configuration for t440p
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p
        ];
      };

      # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
      petalburg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/petalburg
          ./system
          ./users/aly
          ./desktop/gnome
          ./modules/podman
          ./modules/steam
          ./modules/via-qmk

          # Add managed flatpak module.
          nix-flatpak.nixosModules.nix-flatpak

          # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly;
          }
        ];
      };
    };

    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    homeConfigurations.aly = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { 
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      modules = [
        ./home/aly
      ];
    };
  };
}