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
      url = "github:nix-community/lanzaboote/master";
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
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
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
      "lavaridge"
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
            git
            nh
            nix-update
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
      default = ./modules/home-manager;
      aly = ./homes/aly;
      dustin = ./homes/dustin;
    };

    nixosModules = {
      disko-btrfs-subvolumes = ./modules/disko/btrfs-subvolumes;
      disko-luks-btrfs-subvolumes = ./modules/disko/luks-btrfs-subvolumes;
      hardware-amd-cpu = ./modules/hardware/amd/cpu;
      hardware-amd-gpu = ./modules/hardware/amd/gpu;
      hardware-asus-ally-RC72LA = ./modules/hardware/asus/ally/RC72LA;
      hardware-beelink-mini-s12pro = ./modules/hardware/beelink/mini/s12pro;
      hardware-common = ./modules/hardware/common;
      hardware-framework-13-amd-7000 = ./modules/hardware/framework/13/amd-7000;
      hardware-framework-13-intel-11th = ./modules/hardware/framework/13/intel-11th;
      hardware-intel-cpu = ./modules/hardware/intel/cpu;
      hardware-intel-gpu = ./modules/hardware/intel/gpu;
      hardware-lenovo-thinkcentre-m700 = ./modules/hardware/lenovo/thinkcentre/m700;
      hardware-lenovo-thinkpad-5D50X = ./modules/hardware/lenovo/thinkpad/5D50X;
      hardware-lenovo-thinkpad-T440p = ./modules/hardware/lenovo/thinkpad/T440p;
      hardware-lenovo-thinkpad-X1-gen-9 = ./modules/hardware/lenovo/thinkpad/X1/gen-9;
      hardware-lenovo-yoga-16IMH9 = ./modules/hardware/lenovo/yoga/16IMH9;
      hardware-nvidia-gpu = ./modules/hardware/nvidia/gpu;
      hardware-profiles-laptop = ./modules/hardware/profiles/laptop.nix;
      locale-en-us = ./modules/locale/en-us;
      nixos-desktop = ./modules/nixos/desktop;
      nixos-desktop-gnome = ./modules/nixos/desktop/gnome;
      nixos-desktop-hyprland = ./modules/nixos/desktop/hyprland;
      nixos-desktop-kde = ./modules/nixos/desktop/kde;
      nixos-desktop-steamos = ./modules/nixos/desktop/steamos;
      nixos-profiles-autoUpgrade = ./modules/nixos/profiles/autoUpgrade;
      nixos-profiles-base = ./modules/nixos/profiles/base;
      nixos-profiles-btrfs = ./modules/nixos/profiles/btrfs;
      nixos-profiles-desktop = ./modules/nixos/profiles/desktop;
      nixos-profiles-gaming = ./modules/nixos/profiles/gaming;
      nixos-profiles-media-share = ./modules/nixos/profiles/media-share;
      nixos-profiles-server = ./modules/nixos/profiles/server;
      nixos-profiles-wifi = ./modules/nixos/profiles/wifi;
      nixos-programs-firefox = ./modules/nixos/programs/firefox;
      nixos-programs-lanzaboote = ./modules/nixos/programs/lanzaboote;
      nixos-programs-nicotine-plus = ./modules/nixos/programs/nicotine-plus;
      nixos-programs-nix = ./modules/nixos/programs/nix;
      nixos-programs-podman = ./modules/nixos/programs/podman;
      nixos-programs-retroarch = ./modules/nixos/programs/retroarch;
      nixos-programs-steam = ./modules/nixos/programs/steam;
      nixos-programs-virt-manager = ./modules/nixos/programs/virt-manager;
      nixos-services-flatpak = ./modules/nixos/services/flatpak;
      nixos-services-gdm = ./modules/nixos/services/gdm;
      nixos-services-greetd = ./modules/nixos/services/greetd;
      nixos-services-sddm = ./modules/nixos/services/sddm;
      nixos-services-sunshine = ./modules/nixos/services/sunshine;
      nixos-services-syncthing = ./modules/nixos/services/syncthing;
      nixos-services-tailscale = ./modules/nixos/services/tailscale;
      users = ./modules/users;
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
          mdformat
          rubocop
          shfmt
        ];

        text = builtins.readFile ./utils/formatter.sh;
      };
    });
  };
}
