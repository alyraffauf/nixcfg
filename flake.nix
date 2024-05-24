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
