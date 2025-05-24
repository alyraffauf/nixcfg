{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.forgejo-runner = {
    enable = lib.mkEnableOption "Forĝejo runners";

    number = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "How many forgejo runner instances to spawn.";
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

    services.gitea-actions-runner.instances = let
      runnerCount = config.myNixOS.services.forgejo-runner.number;
      runnerIndices = lib.map (i: toString i) (lib.range 1 runnerCount);

      # eg x86_64-linux → x86_64_linux
      arch = lib.replaceStrings ["-"] ["_"] pkgs.system;
    in
      lib.genAttrs runnerIndices (idx: {
        enable = true;

        hostPackages = with pkgs; [
          bash
          cachix
          coreutils
          curl
          gawk
          gitMinimal
          gnused
          jq
          nix
          nodejs
          wget
        ];

        labels =
          [
            "nixos-${arch}:host"
          ]
          ++ lib.optional (arch == "aarch64_linux") "ubuntu-24.04-arm:docker://gitea/runner-images:ubuntu-latest" ++ lib.optional (arch == "x86_64_linux") "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest";

        name = "${arch}-${config.networking.hostName}-${idx}";
        settings.container.network = "host";
        tokenFile = config.age.secrets.act-runner.path;
        url = "http://mossdeep:3001";
      });
  };
}
