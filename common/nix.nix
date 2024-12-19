{...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
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
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://alyraffauf.cachix.org"
        "https://cache.nixos.org/"
        "https://chaotic-nyx.cachix.org/"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      trusted-users = ["aly"];
    };
  };
}
