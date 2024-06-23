{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automated disk partitioning.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Motion sensor and auto-rotate for Hyprland.
    iio-hyprland = {
      url = "github:JeanSchoeller/iio-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stable home-manager, synced with latest stable nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Latest hyprland from git.
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = ["https://nixcache.raffauflabs.com" "https://hyprland.cachix.org"];
    extra-trusted-public-keys = [
      "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs = inputs @ {self, ...}: {
    formatter = inputs.nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);

    packages =
      inputs.nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ] (system: {
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

    homeManagerModules.default =
      import ./homeManagerModules inputs self;

    nixosModules.default =
      import ./nixosModules inputs;

    nixosConfigurations =
      inputs.nixpkgs.lib.genAttrs [
        "fallarbor"
        "lavaridge"
        "mandarin"
        "mauville"
        "petalburg"
        "rustboro"
      ] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs self;};
            modules = [
              ./hosts/${host}
              inputs.agenix.nixosModules.default
              inputs.disko.nixosModules.disko
              inputs.hyprland.nixosModules.default
              inputs.nixvim.nixosModules.nixvim
              inputs.home-manager.nixosModules.home-manager
              self.nixosModules.default
              {
                home-manager = {
                  backupFileExtension = "backup";

                  sharedModules = [
                    inputs.agenix.homeManagerModules.default
                    inputs.hyprland.homeManagerModules.default
                    inputs.nixvim.homeManagerModules.nixvim
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
