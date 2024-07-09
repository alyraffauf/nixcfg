{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    disko.url = "github:nix-community/disko";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
    nixhw.url = "github:alyraffauf/nixhw";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nur.url = "github:nix-community/NUR";
    raffauflabs.url = "github:alyraffauf/raffauflabs";
    wallpapers.url = "github:alyraffauf/wallpapers";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    iio-hyprland.inputs.nixpkgs.follows = "nixpkgs";
    nixhw.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    raffauflabs.inputs.nixpkgs.follows = "nixpkgs";
    wallpapers.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://alyraffauf.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs @ {self, ...}: let
    forDefaultSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forLinuxSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllHosts = inputs.nixpkgs.lib.genAttrs [
      "fallarbor"
      "lavaridge"
      "mandarin"
      "mauville"
      "petalburg"
      "rustboro"
    ];
  in {
    formatter = forDefaultSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);

    packages = forLinuxSystems (system: {
      default = inputs.nixpkgs.legacyPackages."${system}".writeShellScriptBin "clean-install" ''
        # Check if an argument is provided
        if [ $# -eq 0 ]; then
          echo "Error: Please provide a valid hostname as an argument."
          exit 1
        fi

        HOST=$1
        FLAKE=github:alyraffauf/nixcfg#$HOST

        echo "Warning: Running this script will wipe the currently installed system."
        read -p "Do you want to continue? (y/n): " answer

        if [ "$answer" != "y" ]; then
          echo "Aborted."
          exit 0
        fi

        sudo nix --experimental-features "nix-command flakes" run \
            github:nix-community/disko -- --mode disko --flake $FLAKE

        # Install NixOS with the updated flake input and root settings
        sudo nixos-install --no-root-password --root /mnt --flake $FLAKE
      '';
    });

    homeManagerModules = {
      default = import ./homeManagerModules inputs self;
      aly = import ./homes/aly inputs self;
      dustin = import ./homes/dustin inputs self;
      morgan = import ./homes/morgan inputs self;
    };

    nixosModules = {
      base = import ./baseModules inputs;
      nixos = import ./nixosModules inputs;
      users = import ./userModules inputs;
    };

    nixosConfigurations = forAllHosts (
      host:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs self;};
          modules = [
            ./hosts/${host}
            inputs.agenix.nixosModules.default
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            inputs.raffauflabs.nixosModules.raffauflabs
            self.nixosModules.base
            self.nixosModules.nixos
            self.nixosModules.users

            {
              home-manager = {
                backupFileExtension = "backup";
                extraSpecialArgs = {inherit inputs self;};

                sharedModules = [
                  inputs.agenix.homeManagerModules.default
                  inputs.nixvim.homeManagerModules.nixvim
                  inputs.nur.hmModules.nur
                  self.homeManagerModules.default
                ];

                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        }
    );
  };
}
