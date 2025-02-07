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

    nur.url = "github:nix-community/NUR";

    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix/master";
    };

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
    allLinuxSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    allMacSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    allSystems = allLinuxSystems ++ allMacSystems;

    forAllLinuxSystems = f:
      self.inputs.nixpkgs.lib.genAttrs allLinuxSystems (system:
        f {
          pkgs = import self.inputs.nixpkgs {
            inherit overlays system;
            config.allowUnfree = true;
          };
        });

    forAllSystems = f:
      self.inputs.nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import self.inputs.nixpkgs {
            inherit overlays system;
            config.allowUnfree = true;
          };
        });

    forAllHosts = self.inputs.nixpkgs.lib.genAttrs [
      "fallarbor"
      "lilycove"
      "mauville"
      "pacifidlog"
      "petalburg"
      "rustboro"
      "slateport"
      "sootopolis"
    ];

    overlays = [
      self.inputs.nur.overlays.default
      self.overlays.default
    ];
  in {
    devShells = forAllLinuxSystems ({pkgs}: {
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
          ];

        shellHook = ''
          export FLAKE="."
        '';
      };
    });

    formatter = self.inputs.nixpkgs.lib.genAttrs allSystems (system: self.packages.${system}.formatter);

    homeManagerModules = {
      aly = ./homes/aly;
      dustin = ./homes/dustin;
      default = ./modules/home;
    };

    nixosModules = {
      disko-btrfs-subvolumes = ./modules/os/disko/btrfs-subvolumes;
      disko-luks-btrfs-subvolumes = ./modules/os/disko/luks-btrfs-subvolumes;
      hardware-amd-cpu = ./modules/os/hardware/amd/cpu;
      hardware-amd-gpu = ./modules/os/hardware/amd/gpu;
      hardware-asus-ally-RC72LA = ./modules/os/hardware/asus/ally/RC72LA;
      hardware-beelink-mini-s12pro = ./modules/os/hardware/beelink/mini/s12pro;
      hardware-common = ./modules/os/hardware/common;
      hardware-framework-13-amd-7000 = ./modules/os/hardware/framework/13/amd-7000;
      hardware-framework-13-intel-11th = ./modules/os/hardware/framework/13/intel-11th;
      hardware-intel-cpu = ./modules/os/hardware/intel/cpu;
      hardware-intel-gpu = ./modules/os/hardware/intel/gpu;
      hardware-lenovo-thinkcentre-m700 = ./modules/os/hardware/lenovo/thinkcentre/m700;
      hardware-lenovo-thinkpad-5D50X = ./modules/os/hardware/lenovo/thinkpad/5D50X;
      hardware-lenovo-thinkpad-T440p = ./modules/os/hardware/lenovo/thinkpad/T440p;
      hardware-lenovo-thinkpad-X1-gen-9 = ./modules/os/hardware/lenovo/thinkpad/X1/gen-9;
      hardware-lenovo-yoga-16IMH9 = ./modules/os/hardware/lenovo/yoga/16IMH9;
      hardware-nvidia-gpu = ./modules/os/hardware/nvidia/gpu;
      hardware-profiles-laptop = ./modules/os/hardware/profiles/laptop.nix;
      locale-en-us = ./modules/os/locale/en-us;
      nixos = ./modules/os/nixos;
      users = ./modules/os/users;
    };

    nixosConfigurations = forAllHosts (
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

      adjustor = pkgs.callPackage ./pkgs/adjustor.nix {};

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
