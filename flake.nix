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

    # # Declarative Flatpaks.
    # nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
    
    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-unstable, home-manager-unstable, nixos-hardware, ... }: {

    nixosConfigurations = {

      # # Framework 13 with AMD Ryzen 7640U and 32GB RAM.
      # lavaridge = nixpkgs-unstable.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [
      #     ./hosts/lavaridge
      #     ./desktop/gnome

      #     # Add home-manager nixos module so home-manager config deploys on nixos-rebuild.
      #     home-manager-unstable.nixosModules.home-manager
      #     # nixos-hardware configuration for fw13-amd.
      #     nixos-hardware.nixosModules.framework-13-7040-amd
      #   ];
      # };
      
      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/rustboro
          ./desktop/kde
          home-manager-unstable.nixosModules.home-manager
          nixos-hardware.nixosModules.lenovo-thinkpad-t440p
        ];
      };

      # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
      petalburg = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/petalburg
          ./desktop/gnome
          home-manager-unstable.nixosModules.home-manager
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
          home-manager-unstable.nixosModules.home-manager
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
