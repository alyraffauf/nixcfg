{
  config,
  lib,
  self,
  ...
}: {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    programs.ssh.knownHosts = {
      lilycove = {
        hostNames = ["lilycove" "lilycove.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_lilycove.pub";
      };

      mauville = {
        hostNames = ["mauville" "mauville.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_mauville.pub";
      };

      roxanne = {
        hostNames = ["roxanne" "roxanne.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_roxanne.pub";
      };
    };

    nix = {
      buildMachines = let
        sshUser = "root";
        sshKey = "/home/aly/.ssh/id_ed25519";
      in
        lib.filter (m: m.hostName != "${config.networking.hostName}") [
          {
            inherit sshUser sshKey;
            hostName = "lilycove";
            maxJobs = 6;
            speedFactor = 4;
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
            system = "x86_64-linux";
          }
          {
            inherit sshUser sshKey;
            hostName = "mauville";
            maxJobs = 4;
            speedFactor = 1;
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
            system = "x86_64-linux";
          }

          {
            inherit sshUser sshKey;
            hostName = "roxanne";
            maxJobs = 4;
            speedFactor = 1;
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
            system = "aarch64-linux";
          }
        ];

      distributedBuilds = true;

      gc = {
        automatic = true;
        options = "--delete-older-than 5d";
        persistent = true;
        randomizedDelaySec = "60min";
      };

      # Run GC when there is less than 1GiB left.
      extraOptions = ''
        min-free = ${toString (1 * 1024 * 1024 * 1024)}   # 1 GiB
        max-free = ${toString (5 * 1024 * 1024 * 1024)}   # 5 GiB
      '';

      optimise = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "60min";
      };

      settings = {
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
