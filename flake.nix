{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.11";
    };

    iio-hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:JeanSchoeller/iio-hyprland";
    };

    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote/v0.4.1";
    };

    nix-gaming = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:fufexan/nix-gaming";
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
      "https://jovian-nixos.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
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
          pkgs = import self.inputs.nixpkgs {inherit system;};
        });

    forAllSystems = f:
      self.inputs.nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import self.inputs.nixpkgs {inherit system;};
        });

    forAllHosts = self.inputs.nixpkgs.lib.genAttrs [
      "fallarbor"
      "lavaridge"
      "mauville"
      "petalburg"
      "rustboro"
      "slateport"
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
            ruby
            sbctl
          ])
          ++ [
            self.formatter.${pkgs.system}
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
      default = import ./homeManagerModules self;
      aly = import ./homes/aly self;
      dustin = import ./homes/dustin self;
    };

    nixosModules = {
      common-auto-upgrade = import ./common/autoUpgrade.nix;
      common-base = import ./common/base.nix;
      common-locale = import ./common/locale.nix;
      common-mauville-share = import ./common/samba.nix;
      common-nix = import ./common/nix.nix;
      common-pkgs = import ./common/pkgs.nix;
      common-tailscale = import ./common/tailscale.nix;
      common-wifi-profiles = import ./common/wifi.nix;

      hw-common = import ./hwModules/common;
      hw-common-amd-cpu = import ./hwModules/common/gpu/amd;
      hw-common-amd-gpu = import ./hwModules/common/cpu/amd;
      hw-common-bluetooth = import ./hwModules/common/bluetooth;
      hw-common-gaming = import ./hwModules/common/gaming;
      hw-common-intel-cpu = import ./hwModules/common/cpu/intel;
      hw-common-intel-gpu = import ./hwModules/common/gpu/intel;
      hw-common-laptop = import ./hwModules/common/laptop;
      hw-common-laptop-intel-cpu = import ./hwModules/common/laptop/intel-cpu.nix;
      hw-common-ssd = import ./hwModules/common/ssd;

      hw-asus-tuf-a16-amd-7030 = import ./hwModules/asus/tuf/a16/amd-7030/default.nix;
      hw-framework-13-amd-7000 = import ./hwModules/framework/13/amd-7000;
      hw-framework-13-intel-11th = import ./hwModules/framework/13/intel-11th;
      hw-lenovo-legion-go = import ./hwModules/lenovo/legion/go;
      hw-thinkpad-t440p = import ./hwModules/thinkpad/t440p;

      nixos = import ./nixosModules self;
      users = import ./userModules self;
    };

    nixosConfigurations = forAllHosts (
      host:
        self.inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};
          modules = [
            ./hosts/${host}
            self.inputs.agenix.nixosModules.default
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
            }
          ];
        }
    );

    overlays = {
      tablet = import ./overlays/tablet.nix;
      default = import ./overlays/default.nix {inherit self;};
    };

    packages = forAllLinuxSystems ({pkgs}: rec {
      default = clean-install;

      adjustor = pkgs.callPackage ./pkgs/adjustor.nix {};

      clean-install = pkgs.writeShellApplication {
        name = "clean-install";
        text = ./flake/clean-install.sh;
      };

      hhd-ui = pkgs.callPackage ./pkgs/hhd-ui.nix {};
      rofi-bluetooth = pkgs.callPackage ./pkgs/rofi-bluetooth.nix {};
    });
  };
}
