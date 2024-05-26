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
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Automated disk partitioning.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-baked hardware support for various devices.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Useful modules for Steam Deck.
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

  outputs = inputs @ {self, ...}: {
    formatter = inputs.nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);

    packages."x86_64-linux".default = inputs.nixpkgs.legacyPackages."x86_64-linux".writeShellScriptBin "clean-install" ''
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

    nixosModules.default =
      import ./nixosModules inputs;

    nixosConfigurations =
      inputs.nixpkgs.lib.genAttrs [
        "fallarbor"
        "lavaridge"
        "mauville"
        "mossdeep"
        "petalburg"
        "rustboro"
      ] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs self;};
            modules = [
              ./hosts/${host}
            ];
          }
      );
  };
}
