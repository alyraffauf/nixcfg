{
  description = "Aly's NixOS flake with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    actions-nix = {
      url = "github:alyraffauf/actions.nix";

      inputs = {
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    files.url = "github:alyraffauf/files";
    flake-parts.url = "github:hercules-ci/flake-parts";

    fontix = {
      url = "github:alyraffauf/fontix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "git+https://git.lix.systems/lix-project/lix.git?ref=release-2.93";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module.git?ref=release-2.93";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nur.url = "github:nix-community/NUR";

    nynx = {
      url = "github:alyraffauf/nynx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    self2025 = {
      url = "github:alyraffauf/self2025";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-flake inputs
    absolute = {
      url = "github:ZeroQI/Absolute-Series-Scanner";
      flake = false;
    };

    audnexus = {
      url = "github:djdembeck/Audnexus.bundle";
      flake = false;
    };

    hama = {
      url = "github:ZeroQI/Hama.bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    secrets = {
      url = "github:alyraffauf/secrets";
      flake = false;
    };

    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false;
    };
  };

  nixConfig = {
    accept-flake-config = true;

    extra-substituters = [
      "https://alyraffauf.cachix.org"
      "https://chaotic-nyx.cachix.org/"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      imports = [
        ./modules/flake
        inputs.actions-nix.flakeModules.default
        inputs.files.flakeModules.default
        inputs.git-hooks-nix.flakeModule
        inputs.home-manager.flakeModules.home-manager
        inputs.treefmt-nix.flakeModule
      ];
    };
}
