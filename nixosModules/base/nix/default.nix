{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.base.enable {
    environment.variables = {
      FLAKE = "github:alyraffauf/nixcfg";
    };

    programs.nh.enable = true;

    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
        persistent = true;
        randomizedDelaySec = "60min";
      };

      # Run GC when there is less than 100MiB left.
      extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      optimise.automatic = true;

      settings = {
        auto-optimise-store = false;
        experimental-features = ["nix-command" "flakes"];

        substituters = [
          "https://nixcache.raffauflabs.com"
          "https://hyprland.cachix.org"
          "https://cache.nixos.org/"
        ];

        trusted-public-keys = [
          "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];

        trusted-users = ["aly"];
      };
    };
  };
}
