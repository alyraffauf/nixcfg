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

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote/v0.4.2";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    secrets = {
      url = "github:alyraffauf/secrets";
      flake = false;
    };

    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false; # This is important to specify that it's a non-flake
    };
  };

  nixConfig = {
    accept-flake-config = true;

    extra-substituters = [
      "https://alyraffauf.cachix.org"
      "https://chaotic-nyx.cachix.org/"
      "https://jovian-nixos.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {self, ...}: let
    allSystems = [
      "aarch64-linux"
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
      "fallarbor"
      "lilycove"
      "mauville"
      "pacifidlog"
      "petalburg"
      "roxanne"
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
        self.inputs.stylix.darwinModules.stylix

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
            alejandra
            bash-language-server
            git
            nh
            nix-update
            nixd
            nodePackages.prettier
            rubocop
            shellcheck
            shfmt
          ])
          ++ [
            self.inputs.agenix.packages.${pkgs.system}.default
            self.packages.${pkgs.system}.default
            self.packages.${pkgs.system}.deployer
          ];

        shellHook = ''
          export FLAKE="."
        '';
      };
    });

    formatter = self.inputs.nixpkgs.lib.genAttrs allSystems (system: self.packages.${system}.formatter);

    homeManagerModules = {
      aly = ./homes/aly;
      aly-darwin = ./homes/aly/darwin.nix;
      default = ./modules/home;
      dustin = ./homes/dustin;
    };

    nixosModules = {
      disko-btrfs-subvolumes = ./modules/nixos/disko/btrfs-subvolumes;
      disko-luks-btrfs-subvolumes = ./modules/nixos/disko/luks-btrfs-subvolumes;
      hardware-amd-cpu = ./modules/nixos/hardware/amd/cpu;
      hardware-amd-gpu = ./modules/nixos/hardware/amd/gpu;
      hardware-asus-ally-RC72LA = ./modules/nixos/hardware/asus/ally/RC72LA;
      hardware-beelink-mini-s12pro = ./modules/nixos/hardware/beelink/mini/s12pro;
      hardware-common = ./modules/nixos/hardware/common;
      hardware-framework-13-amd-7000 = ./modules/nixos/hardware/framework/13/amd-7000;
      hardware-framework-13-intel-11th = ./modules/nixos/hardware/framework/13/intel-11th;
      hardware-intel-cpu = ./modules/nixos/hardware/intel/cpu;
      hardware-intel-gpu = ./modules/nixos/hardware/intel/gpu;
      hardware-lenovo-thinkcentre-m700 = ./modules/nixos/hardware/lenovo/thinkcentre/m700;
      hardware-lenovo-thinkpad-5D50X = ./modules/nixos/hardware/lenovo/thinkpad/5D50X;
      hardware-lenovo-thinkpad-T440p = ./modules/nixos/hardware/lenovo/thinkpad/T440p;
      hardware-lenovo-thinkpad-X1-gen-9 = ./modules/nixos/hardware/lenovo/thinkpad/X1/gen-9;
      hardware-lenovo-yoga-16IMH9 = ./modules/nixos/hardware/lenovo/yoga/16IMH9;
      hardware-nvidia-gpu = ./modules/nixos/hardware/nvidia/gpu;
      hardware-profiles-laptop = ./modules/nixos/hardware/profiles/laptop.nix;
      locale-en-us = ./modules/nixos/locale/en-us;
      nixos = ./modules/nixos/os;
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
            self.inputs.stylix.nixosModules.stylix
            self.inputs.vscode-server.nixosModules.default
            self.nixosModules.nixos
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

      deployer = pkgs.writeShellApplication {
        name = "deployer";

        runtimeInputs = with pkgs; [
          jq
          nixos-rebuild
        ];

        text = builtins.readFile ./utils/deployer.sh;
      };

      installer = pkgs.writeShellApplication {
        name = "installer";
        text = builtins.readFile ./utils/installer.sh;
      };

      formatter = pkgs.writeShellApplication {
        name = "formatter";

        runtimeInputs = with pkgs; [
          alejandra
          findutils
          nodePackages.prettier
          rubocop
          shfmt
        ];

        text = builtins.readFile ./utils/formatter.sh;
      };
    });
  };
}
