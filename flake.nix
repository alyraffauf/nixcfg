{
  description = "Aly's NixOS configuration.";

  inputs = {
    # Latest Stable NixOS, tracked by FlakeHub.
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

    # Home-manager, used for managing user configuration.
    # Tracks latest stable version using FlakeHub.
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.*.*.tar.gz";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable NixOS channel.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager, used for managing user configuration.
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Declarative Flatpaks.
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
    
    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };<nixos-hardware/framework/13-inch/7040-amd>

  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-unstable, home-manager-unstable, nix-flatpak, nixos-hardware, ... }: {

    nixosConfigurations = {
      
      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/rustboro
          ./desktop/kde

          # Add managed flatpak module.
          nix-flatpak.nixosModules.nix-flatpak

          # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
          home-manager-unstable.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly;
          }

          # nixos-hardware configuration for t440p
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p
        ];
      };

      # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
      petalburg = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/petalburg
          ./desktop/gnome

          # Add managed flatpak module.
          nix-flatpak.nixosModules.nix-flatpak

          # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
          home-manager-unstable.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly;
          }
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          nixos-hardware.nixosModules.common-cpu-intel
        ];
      };

      # Ryzen 5 2600 with 16GB RAM, RX 6700.
      mauville = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/mauville
          ./desktop/gnome
          ./modules/homelab
          ./modules/steam

          # Add managed flatpak module.
          nix-flatpak.nixosModules.nix-flatpak

          # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
          home-manager-unstable.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly;
          }
        ];
      };

      live-gnome-unstable = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix")
          ./system
          ./desktop/gnome

          # Add managed flatpak module.
          nix-flatpak.nixosModules.nix-flatpak

          # Add installer.
          ({ pkgs, ... }: {
            environment.systemPackages = [ pkgs.calamares-nixos pkgs.calamares-nixos-extensions ];
          })
          # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
          home-manager-unstable.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = import ./home/nixos;
          }
        ];
      };
    };

    packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;
    homeConfigurations.aly = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs-unstable { 
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
