{
  description = "Aly's NixOS flake with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable";

    actions-nix = {
      url = "github:alyraffauf/actions.nix";

      inputs = {
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:yaxitech/ragenix";
    };

    aws-cvpn-client = {
      url = "github:alyraffauf/aws-cvpn-client";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

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
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
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

    safari = {
      url = "github:alyraffauf/safari";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snippets = {
      url = "github:alyraffauf/snippets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-flake inputs

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
