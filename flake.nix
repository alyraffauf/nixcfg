{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      url = "github:nix-community/home-manager/master";
    };

    iio-hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:JeanSchoeller/iio-hyprland";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
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
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
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

    packages = forAllLinuxSystems ({pkgs}: {
      default = pkgs.writeShellApplication {
        name = "clean-install";
        text = ./flake/clean-install.sh;
      };
    });

    homeManagerModules = {
      default = import ./homeManagerModules self;
      aly = import ./homes/aly self;
      dustin = import ./homes/dustin self;
      morgan = import ./homes/morgan self;
    };

    nixosModules = {
      common-auto-upgrade = import ./common/autoUpgrade.nix;
      common-base = import ./common/base.nix;
      common-locale = import ./common/locale.nix;
      common-mauville-share = import ./common/samba.nix;
      common-nix = import ./common/nix.nix;
      common-overlays = import ./common/overlays.nix;
      common-pkgs = import ./common/pkgs.nix;
      common-tailscale = import ./common/tailscale.nix;
      common-wifi-profiles = import ./common/wifi.nix;

      hw-common-amd-cpu = import ./hwModules/common/gpu/amd;
      hw-common-amd-gpu = import ./hwModules/common/cpu/amd;
      hw-common-bluetooth = import ./hwModules/common/bluetooth;
      hw-common-intel-cpu = import ./hwModules/common/cpu/intel;
      hw-common-intel-gpu = import ./hwModules/common/gpu/intel;
      hw-common-laptop = import ./hwModules/common/laptop;
      hw-common-laptop-amd-gpu = import ./hwModules/common/laptop/amd-gpu.nix;
      hw-common-laptop-intel-cpu = import ./hwModules/common/laptop/intel-cpu.nix;
      hw-common-ssd = import ./hwModules/common/ssd;
      hw-framework-13-amd-7000 = import ./hwModules/framework/13/amd-7000;
      hw-framework-13-intel-11th = import ./hwModules/framework/13/intel-11th;
      hw-lenovo-yoga-9i-intel-13th = import ./hwModules/lenovo/yoga-9i/intel-13th;
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
  };
}
