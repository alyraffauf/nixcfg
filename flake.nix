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

    ghostty.url = "github:ghostty-org/ghostty";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    iio-hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:JeanSchoeller/iio-hyprland";
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

    homeConfigurations = {
      "aly@petalburg" = self.inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit self;};
        pkgs = import self.inputs.nixpkgs {
          inherit overlays;
          config.allowUnfree = true; # Allow unfree packages
          system = "x86_64-linux";
        };

        modules = [
          self.homeManagerModules.aly-petalburg
        ];
      };
    };

    homeManagerModules = {
      default = import ./homeManagerModules self;
      aly = import ./homes/aly self;
      aly-petalburg = import ./homes/aly/petalburg.nix self;
      dustin = import ./homes/dustin self;
    };

    nixosModules = {
      common-base = import ./common/base.nix;
      common-lanzaboote = import ./common/lanzaboote.nix;
      common-locale = import ./common/locale.nix;
      common-mauville-share = import ./common/samba.nix;
      common-nix = import ./common/nix.nix;
      common-pkgs = import ./common/pkgs.nix;
      common-systemd-boot = import ./common/systemd-boot.nix;
      common-tailscale = import ./common/tailscale.nix;
      common-wifi-profiles = import ./common/wifi.nix;

      hw-common = import ./hwModules/common;
      hw-common-amd-cpu = import ./hwModules/common/gpu/amd;
      hw-common-amd-gpu = import ./hwModules/common/cpu/amd;
      hw-common-bluetooth = import ./hwModules/common/bluetooth;
      hw-common-intel-cpu = import ./hwModules/common/cpu/intel;
      hw-common-intel-gpu = import ./hwModules/common/gpu/intel;
      hw-common-laptop = import ./hwModules/common/laptop;
      hw-common-laptop-intel-cpu = import ./hwModules/common/laptop/intel-cpu.nix;
      hw-common-ssd = import ./hwModules/common/ssd;

      hw-asus-tuf-a16-amd-7030 = import ./hwModules/asus/tuf/a16/amd-7030/default.nix;
      hw-framework-13-amd-7000 = import ./hwModules/framework/13/amd-7000;
      hw-framework-13-intel-11th = import ./hwModules/framework/13/intel-11th;
      hw-thinkpad-t440p = import ./hwModules/thinkpad/t440p;

      nixos-desktop-gnome = import ./nixosModules/desktop/gnome.nix;
      nixos-desktop-gui = import ./nixosModules/desktop/gui.nix;
      nixos-desktop-hyprland = import ./nixosModules/desktop/hyprland.nix;
      nixos-desktop-kde = import ./nixosModules/desktop/kde.nix;

      nixos-profiles-autoUpgrade = import ./nixosModules/profiles/autoUpgrade.nix;
      nixos-profiles-btrfs = import ./nixosModules/profiles/btrfs.nix;
      nixos-profiles-desktop = import ./nixosModules/profiles/desktop.nix;

      nixos-programs-firefox = import ./nixosModules/programs/firefox.nix;
      nixos-programs-nicotine-plus = import ./nixosModules/programs/nicotine-plus.nix;
      nixos-programs-podman = import ./nixosModules/programs/podman.nix;
      nixos-programs-steam = import ./nixosModules/programs/steam.nix;
      nixos-programs-virt-manager = import ./nixosModules/programs/virt-manager.nix;

      nixos-services-flatpak = import ./nixosModules/services/flatpak.nix;
      nixos-services-gdm = import ./nixosModules/services/gdm.nix;
      nixos-services-greetd = import ./nixosModules/services/greetd.nix;
      nixos-services-sddm = import ./nixosModules/services/sddm.nix;

      users = import ./userModules self;
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
