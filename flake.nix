{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    chaotic = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

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
      url = "github:nix-community/lanzaboote/v0.4.1";
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
      "petalburg"
      "rustboro"
      "slateport"
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
            e2fsprogs
            git
            mdformat
            nh
            nix-update
            sbctl
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

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);

    homeManagerModules = {
      default = import ./modules/home-manager self;
      aly = import ./homes/aly self;
      dustin = import ./homes/dustin self;
    };

    nixosModules = {
      common-mauville-share = import ./modules/common/samba.nix;
      common-wifi-profiles = import ./modules/common/wifi.nix;
      disko-btrfs-subvolumes = import ./modules/disko/btrfs-subvolumes;
      disko-luks-btrfs-subvolumes = import ./modules/disko/luks-btrfs-subvolumes;
      hw-amd-cpu = import ./modules/hardware/amd/cpu;
      hw-amd-gpu = import ./modules/hardware/amd/gpu;
      hw-beelink-mini-s12pro = import ./modules/hardware/beelink/mini/s12pro;
      hw-common = import ./modules/hardware/common;
      hw-framework-13-amd-7000 = import ./modules/hardware/framework/13/amd-7000;
      hw-framework-13-intel-11th = import ./modules/hardware/framework/13/intel-11th;
      hw-intel-cpu = import ./modules/hardware/intel/cpu;
      hw-intel-gpu = import ./modules/hardware/intel/gpu;
      hw-lenovo-thinkcentre-m700 = import ./modules/hardware/lenovo/thinkcentre/m700;
      hw-lenovo-thinkpad-5D50X = import ./modules/hardware/lenovo/thinkpad/5D50X;
      hw-lenovo-thinkpad-T440p = import ./modules/hardware/lenovo/thinkpad/T440p;
      hw-lenovo-yoga-16IMH9 = import ./modules/hardware/lenovo/yoga/16IMH9;
      hw-nvidia-gpu = import ./modules/hardware/nvidia/gpu;
      hw-profiles-laptop = import ./modules/hardware/profiles/laptop.nix;
      locale-en-us = import ./modules/locale/en-us;
      nixos-desktop = import ./modules/nixos/desktop;
      nixos-desktop-gnome = import ./modules/nixos/desktop/gnome;
      nixos-desktop-hyprland = import ./modules/nixos/desktop/hyprland;
      nixos-desktop-kde = import ./modules/nixos/desktop/kde;
      nixos-profiles-autoUpgrade = import ./modules/nixos/profiles/autoUpgrade;
      nixos-profiles-base = import ./modules/nixos/profiles/base;
      nixos-profiles-btrfs = import ./modules/nixos/profiles/btrfs;
      nixos-profiles-desktopOptimizations = import ./modules/nixos/profiles/desktopOptimizations;
      nixos-profiles-gaming = import ./modules/nixos/profiles/gaming;
      nixos-profiles-serverOptimizations = import ./modules/nixos/profiles/serverOptimizations;
      nixos-programs-firefox = import ./modules/nixos/programs/firefox;
      nixos-programs-lanzaboote = import ./modules/nixos/programs/lanzaboote;
      nixos-programs-nicotine-plus = import ./modules/nixos/programs/nicotine-plus;
      nixos-programs-nix = import ./modules/nixos/programs/nix;
      nixos-programs-podman = import ./modules/nixos/programs/podman;
      nixos-programs-retroarch = import ./modules/nixos/programs/retroarch;
      nixos-programs-steam = import ./modules/nixos/programs/steam;
      nixos-programs-virt-manager = import ./modules/nixos/programs/virt-manager;
      nixos-services-flatpak = import ./modules/nixos/services/flatpak;
      nixos-services-gdm = import ./modules/nixos/services/gdm;
      nixos-services-greetd = import ./modules/nixos/services/greetd;
      nixos-services-sddm = import ./modules/nixos/services/sddm;
      nixos-services-sunshine = import ./modules/nixos/services/sunshine;
      nixos-services-syncthing = import ./modules/nixos/services/syncthing;
      nixos-services-tailscale = import ./modules/nixos/services/tailscale;
      users = import ./modules/users;
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

    packages = forAllLinuxSystems ({pkgs}: rec {
      default = clean-install;

      clean-install = pkgs.writeShellApplication {
        name = "clean-install";
        text = ./flake/clean-install.sh;
      };
    });
  };
}
