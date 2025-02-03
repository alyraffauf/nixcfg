{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
        persistent = true;
        randomizedDelaySec = "60min";
      };

      # Run GC when there is less than 1GiB left.
      extraOptions = ''
        min-free = ${toString (1 * 1024 * 1024 * 1024)}   # 1 GiB
        max-free = ${toString (5 * 1024 * 1024 * 1024)}   # 5 GiB
      '';

      optimise.automatic = true;

      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];

        substituters = [
          "https://alyraffauf.cachix.org"
          "https://cache.nixos.org/"
          "https://chaotic-nyx.cachix.org/"
          "https://jovian-nixos.cachix.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
          "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        trusted-users = ["@wheel"];
      };
    };

    programs.nix-ld.enable = true;
  };
}
