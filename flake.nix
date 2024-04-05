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

    disko-unstable.url = "github:nix-community/disko";
    disko-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    impermanence.url = "github:nix-community/impermanence";

    # Latest Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  nixConfig = {
    extra-substituters =
      [ "https://nixcache.raffauflabs.com" "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [
      "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager
    , home-manager-unstable, nixos-hardware, impermanence, disko, disko-unstable
    , ... }: {

      homeConfigurations.aly =
        home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable { system = "x86_64-linux"; };
          modules = [ ./home.nix ];
        };

      nixosConfigurations = {

        # Framework 13 with AMD Ryzen 7640U and 32GB RAM.
        lavaridge = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            home-manager-unstable.nixosModules.home-manager
            ./hosts/lavaridge
            ./nixosModules
          ];
        };

        # Home Lab. Ryzen 5 2600 with 16GB RAM, RX 6700.
        mauville = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager-unstable.nixosModules.home-manager
            ./hosts/mauville
            ./nixosModules
          ];
        };

        # Lenovo Yoga 9i with i7-1360P and 16GB RAM.
        petalburg = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            home-manager-unstable.nixosModules.home-manager
            ./hosts/petalburg
            ./nixosModules
          ];
        };

        # T440p with i5-4210M and 16GB RAM.
        rustboro = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            disko-unstable.nixosModules.disko
            impermanence.nixosModules.impermanence
            nixos-hardware.nixosModules.lenovo-thinkpad-t440p
            home-manager-unstable.nixosModules.home-manager
            ./hosts/rustboro
            ./nixosModules
          ];
        };
      };
    };
}
