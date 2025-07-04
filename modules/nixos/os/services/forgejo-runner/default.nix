{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.forgejo-runner = {
    enable = lib.mkEnableOption "Forĝejo runners";

    nativeRunners = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "How many native NixOS runners to run for the Forĝejo runner.";
    };

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
      instances = let
        tokenFile = config.age.secrets.act-runner.path;
      in {
        alycodes-containers = {
          inherit tokenFile;
          enable = true;

          labels = lib.optional (arch == "aarch64_linux") "ubuntu-24.04-arm:docker://gitea/runner-images:ubuntu-latest" ++ lib.optional (arch == "x86_64_linux") "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest-full";

          name = "${arch}-${config.networking.hostName}-alycodes-containers";

          settings = {
            container.network = "host";
            runner.capacity = config.myNixOS.services.forgejo-runner.dockerContainers;
          };

          url = "http://${config.mySnippets.cute-haus.networkMap.forgejo.hostName}:${toString config.mySnippets.cute-haus.networkMap.forgejo.port}";
        };

        alycodes-nixos = {
          inherit tokenFile;
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

          labels = ["nixos-${arch}:host"];
          name = "${arch}-${config.networking.hostName}-alycodes-nixos";

          settings = {
            container.network = "host";
            runner.capacity = config.myNixOS.services.forgejo-runner.nativeRunners;
          };

          url = "http://${config.mySnippets.cute-haus.networkMap.forgejo.hostName}:${toString config.mySnippets.cute-haus.networkMap.forgejo.port}";
        };
      };
    };
  };
}
