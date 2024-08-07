{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";

  nix.settings = {
    substituters = [
      "https://alyraffauf.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trusted-users = ["aly"];
  };

  nixpkgs = {
    config.allowUnfree = true; # Allow unfree packages

    overlays = [
      (final: prev: {
        rbw = prev.rbw.override (super: {
          rustPlatform =
            super.rustPlatform
            // {
              buildRustPackage = args:
                super.rustPlatform.buildRustPackage (args
                  // {
                    version = "1.12.1";
                    src = pkgs.fetchFromGitHub {
                      owner = "doy";
                      repo = "rbw";
                      rev = "1.12.1";
                      hash = "sha256-+1kalFyhk2UL+iVzuFLDsSSTudrd4QpXw+3O4J+KsLc=";
                    };
                    cargoHash = "sha256-cKbbsDb449WANGT+x8APhzs+hf5SR3RBsCBWDNceRMA=";
                  });
            };
        });

        rofi-bluetooth =
          prev.rofi-bluetooth.overrideAttrs
          (old: {
            version = "unstable-2024-07-25";

            src = pkgs.fetchFromGitHub {
              owner = "alyraffauf";
              repo = old.pname;
              rev = "50252e4a9aebe4899a6ef2f7bc11d91b7e4aa8ae";
              sha256 = "sha256-o0Sr3/888L/2KzZZP/EcXx+8ZUzdHB/I/VIeVuJvJks=";
            };
          });
      })
    ];
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "02:00";
    flags = ["--accept-flake-config"];
    flake = config.environment.variables.FLAKE;
    operation = "switch";
    persistent = true;
    randomizedDelaySec = "30min";

    rebootWindow = {
      lower = "02:00";
      upper = "06:00";
    };
  };
}
