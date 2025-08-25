{lib, ...}: {
  options = {
    mySnippets.nix.settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Default nix settings shared across machines.";

      default = {
        builders-use-substitutes = true;

        experimental-features = [
          "fetch-closure"
          "flakes"
          "nix-command"
          "recursive-nix"
        ];

        substituters = [
          "https://alyraffauf.cachix.org"
          "https://cache.nixos.org/"
          "https://catppuccin.cachix.org"
          "https://chaotic-nyx.cachix.org/"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        trusted-users = ["aly" "@admin" "@wheel" "nixbuild"];
      };
    };
  };
}
