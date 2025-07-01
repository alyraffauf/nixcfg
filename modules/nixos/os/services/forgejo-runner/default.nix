{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.forgejo-runner = {
    enable = lib.mkEnableOption "Forĝejo runners";

    dockerContainers = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "How many docker containers to run for the Forĝejo runner.";
    };
  };

  config = lib.mkIf config.myNixOS.services.forgejo-runner.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "We contact Forĝejo over tailscale, but services.tailscale.enable != true.";
      }
    ];

    age.secrets.act-runner.file = "${self.inputs.secrets}/act-runner.age";
    nix.gc.options = lib.mkForce "--delete-older-than 20d";

    services.gitea-actions-runner = let
      arch = lib.replaceStrings ["-"] ["_"] pkgs.system;
    in {
      package = pkgs.forgejo-runner;

      instance = {
        alycodes-containers = {
          enable = true;

          labels = lib.optional (arch == "aarch64_linux") "ubuntu-24.04-arm:docker://gitea/runner-images:ubuntu-latest" ++ lib.optional (arch == "x86_64_linux") "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest";

          name = "${arch}-${config.networking.hostName}-alycodes-containers";

          settings = {
            container.network = "host";
            runner.capacity = config.myNixOS.services.forgejo-runner.dockerContainers;
          };

          tokenFile = config.age.secrets.act-runner.path;
          url = "http://mossdeep:3001";
        };

        alycodes-nixos = {
          enable = true;

          hostPackages = with pkgs;
            [
              bash
              cachix
              coreutils
              curl
              gawk
              gitMinimal
              gnused
              jq
              nodejs
              wget
            ]
            ++ [config.nix.package];

          labels = [
            "nixos-${arch}:host"
          ];

          name = "${arch}-${config.networking.hostName}-alycodes-nixos";
          settings.container.network = "host";
          tokenFile = config.age.secrets.act-runner.path;
          url = "http://mossdeep:3001";
        };
      };

      # instances = let
      #   runnerCount = config.myNixOS.services.forgejo-runner.number;
      #   runnerIndices = lib.map toString (lib.range 1 runnerCount);

      #   # eg x86_64-linux → x86_64_linux
      #   arch = lib.replaceStrings ["-"] ["_"] pkgs.system;
      # in
      #   lib.genAttrs runnerIndices (idx: {
      #     enable = true;

      #     hostPackages = with pkgs;
      #       [
      #         bash
      #         cachix
      #         coreutils
      #         curl
      #         gawk
      #         gitMinimal
      #         gnused
      #         jq
      #         nodejs
      #         wget
      #       ]
      #       ++ [config.nix.package];

      #     labels =
      #       [
      #         "nixos-${arch}:host"
      #       ]
      #       ++ lib.optional (arch == "aarch64_linux") "ubuntu-24.04-arm:docker://gitea/runner-images:ubuntu-latest" ++ lib.optional (arch == "x86_64_linux") "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest";

      #     name = "${arch}-${config.networking.hostName}-${idx}";

      #     settings = {
      #       container.network = "host";
      #       runner.capacity = 2;
      #     };

      #     tokenFile = config.age.secrets.act-runner.path;
      #     url = "http://mossdeep:3001";
      #   });
    };
  };
}
