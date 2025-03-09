{
  config,
  lib,
  ...
}: {
  options.myDarwin.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myDarwin.programs.nix.enable {
    nix = {
      buildMachines =
        lib.filter (m: m.hostName != "${config.networking.hostName}") (import ../../../nixos/os/programs/nix/buildMachines.nix);

      distributedBuilds = true;

      gc = {
        automatic = true;

        interval = [
          {
            Hour = 9;
          }
        ];
      };

      linux-builder = {
        enable = true;
        ephemeral = true;

        config.virtualisation = {
          cores = 6;

          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
        };

        maxJobs = 4;
      };

      settings = {
        builders-use-substitutes = true;
        experimental-features = "nix-command flakes";

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

        trusted-users = ["@admin"];
      };
    };
  };
}
