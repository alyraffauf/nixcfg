{
  description = "Aly's NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # handles flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, nix-flatpak, home-manager, nixos-hardware, ... }: {
    nixosConfigurations = {
      
      # T440p with i5-4210M and 16GB RAM.
      rustboro = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/rustboro
          ./system
          ./flatpak
          ./hardware
          ./network
          ./desktop/gnome
          ./programs/podman
          ./programs/steam
          ./programs/via-qmk

          nix-flatpak.nixosModules.nix-flatpak
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
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
          ./flatpak
          ./hardware
          ./network
          ./desktop/gnome
          ./programs/podman
          ./programs/steam
          ./programs/via-qmk

          nix-flatpak.nixosModules.nix-flatpak
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./users/aly.nix;
          }
        ];
      };
    };
  };
}