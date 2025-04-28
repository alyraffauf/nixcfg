{
  config,
  lib,
  self,
  ...
}: {
  options.myNixOS.profiles.forgejo-runner = {
    enable =
      lib.mkEnableOption "Forĝejo runners";

    number = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "How many forgejo runner instances to spawn.";
    };
  };

  config = lib.mkIf config.myNixOS.profiles.forgejo-runner.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "We contact Forĝejo over tailscale, but services.tailscale.enable != true.";
      }
    ];

    age.secrets.act-runner.file = "${self.inputs.secrets}/act-runner.age";

    services.gitea-actions-runner.instances = let
      runnerCount = config.myNixOS.profiles.forgejo-runner.number;
      # turn [1 2 … N] into ["1" "2" … "N"]
      runnerIndices = lib.map (i: toString i) (lib.range 1 runnerCount);
    in
      lib.genAttrs runnerIndices (idx: {
        enable = true;

        labels = [
          "native:host"
          "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
          "ubuntu-24.04-arm:docker://gitea/runner-images:ubuntu-latest"
        ];

        name = "${config.networking.hostName}-${idx}";
        settings.container.network = "host";
        tokenFile = config.age.secrets.act-runner.path;
        url = "http://mauville:3000";
      });
  };
}
