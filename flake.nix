{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote/v0.4.2";
    };

    lix = {
      url = "git+https://git.lix.systems/lix-project/lix.git?ref=release-2.93";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module.git?ref=release-2.93";

      inputs = {
        lix.follows = "lix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nur.url = "github:nix-community/NUR";

    self2025 = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:alyraffauf/self2025";
    };

    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ############################################################################
    # Non-flake inputs

    ## Absolute scanner for Plex
    absolute = {
      url = "github:ZeroQI/Absolute-Series-Scanner";
      flake = false;
    };

    ## Plex for Audiobooks
    audnexus = {
      url = "github:djdembeck/Audnexus.bundle";
      flake = false;
    };

    ## Plex for Anime
    hama = {
      url = "github:ZeroQI/Hama.bundle";
      flake = false;
    };

    ## Declarative tap management for homebrew
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    ## All my age-encrypted secrets
    secrets = {
      url = "github:alyraffauf/secrets";
      flake = false;
    };

    ## All my wallpapers
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

  outputs = {self, ...}: let
    allSystems = [
      "aarch64-darwin"
      "x86_64-linux"
    ];

    forAllSystems = f:
      self.inputs.nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import self.inputs.nixpkgs {
            inherit overlays system;
            config.allowUnfree = true;
          };
        });

    forAllLinuxHosts = self.inputs.nixpkgs.lib.genAttrs [
      "evergrande"
      "fallarbor"
      "lavaridge"
      "lilycove"
      "littleroot"
      "mauville"
      "mossdeep"
      "oldale"
      "petalburg"
      "rustboro"
      "slateport"
      "sootopolis"
      "verdanturf"
    ];

    overlays = [
      self.inputs.nur.overlays.default
      self.overlays.default
    ];
  in {
    darwinConfigurations."fortree" = self.inputs.nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/fortree
        self.darwinModules.default
        self.inputs.agenix.darwinModules.default
        self.inputs.home-manager.darwinModules.home-manager
        self.inputs.lix-module.nixosModules.default
        self.inputs.nix-homebrew.darwinModules.nix-homebrew
        self.inputs.stylix.darwinModules.stylix
        self.nixosModules.snippets
        {
          home-manager = {
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit self;};
            useGlobalPkgs = true;
            useUserPackages = true;
          };

          nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
          };
        }
      ];

      specialArgs = {inherit self;};
    };

    darwinModules.default = ./modules/darwin;

    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages =
          (with pkgs; [
            (lib.hiPrio uutils-coreutils-noprefix)
            alejandra
            bash-language-server
            deadnix
            git
            go
            gopls
            nh
            nix-update
            nixd
            nodePackages.prettier
            rubocop
            shellcheck
            shfmt
            statix
          ])
          ++ [
            self.inputs.agenix.packages.${pkgs.system}.default
            self.inputs.disko.packages.${pkgs.system}.disko-install
            self.packages.${pkgs.system}.default
            self.packages.${pkgs.system}.deployer
          ];

        shellHook = ''
          export FLAKE="." NH_FLAKE="."
        '';
      };
    });

    diskoConfigurations = {
      btrfs-subvolumes = ./modules/nixos/disko/btrfs-subvolumes;
      luks-btrfs-subvolumes = ./modules/nixos/disko/luks-btrfs-subvolumes;
      lvm-ext4 = ./modules/nixos/disko/lvm-ext4;
    };

    formatter = self.inputs.nixpkgs.lib.genAttrs allSystems (system: self.packages.${system}.formatter);

    homeManagerModules = {
      aly = ./homes/aly;
      default = ./modules/home;
      dustin = ./homes/dustin;
      snippets = ./modules/snippets;
    };

    nixosModules = {
      hardware = ./modules/nixos/hardware;
      locale-en-us = ./modules/nixos/locale/en-us;
      nixos = ./modules/nixos/os;
      snippets = ./modules/snippets;
      users = ./modules/nixos/users;
    };

    nixosConfigurations = forAllLinuxHosts (
      host:
        self.inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};

          modules = [
            ./hosts/${host}
            self.inputs.agenix.nixosModules.default
            self.inputs.chaotic.homeManagerModules.default
            self.inputs.disko.nixosModules.disko
            self.inputs.home-manager.nixosModules.home-manager
            self.inputs.lanzaboote.nixosModules.lanzaboote
            self.inputs.lix-module.nixosModules.default
            self.inputs.stylix.nixosModules.stylix
            self.inputs.vscode-server.nixosModules.default
            self.nixosModules.hardware
            self.nixosModules.nixos
            self.nixosModules.snippets
            self.nixosModules.users
            {
              home-manager = {
                backupFileExtension = "backup";
                extraSpecialArgs = {inherit self;};
                useGlobalPkgs = true;
                useUserPackages = true;
              };

              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
            }
          ];
        }
    );

    overlays.default = import ./overlays/default.nix {inherit self;};

    packages = forAllSystems ({pkgs}: rec {
      default = installer;

      deployer = pkgs.stdenv.mkDerivation {
        pname = "deployer";
        version = "0.1.0";
        src = self + /utils; # directory with deployer.go

        nativeBuildInputs = [pkgs.go];
        dontConfigure = true;

        buildPhase = ''
          export GO111MODULE=off               # GOPATH mode
          export GOCACHE="$TMPDIR/go-cache"    # writable cache
          mkdir -p "$GOCACHE"

          go build -o deployer .
        '';

        installPhase = ''
          install -Dm755 deployer $out/bin/deployer
        '';
      };

      installer = pkgs.writeShellApplication {
        name = "installer";
        text = builtins.readFile ./utils/installer.sh;
      };

      formatter = pkgs.writeShellApplication {
        name = "formatter";

        runtimeInputs = with pkgs; [
          alejandra
          deadnix
          findutils
          gopls
          nodePackages.prettier
          rubocop
          shfmt
          statix
        ];

        text = builtins.readFile ./utils/formatter.sh;
      };
    });
  };
}
