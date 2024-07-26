{
  config,
  pkgs,
  ...
}: {
  environment.variables.FLAKE = "github:alyraffauf/nixcfg";

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
    allowReboot = true;
    dates = "02:00";
    flags = ["--accept-flake-config"];
    flake = config.environment.variables.FLAKE;
    operation = "switch";
    persistent = true;
    randomizedDelaySec = "30min";

    rebootWindow = {
      lower = "04:00";
      upper = "06:00";
    };
  };
}
