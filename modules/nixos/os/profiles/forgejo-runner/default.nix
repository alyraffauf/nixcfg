{
  config,
  lib,
  self,
  ...
}: {
  options.myNixOS.profiles.forgejo-runner.enable = lib.mkEnableOption "forĝejo runner";
  config = lib.mkIf config.myNixOS.profiles.forgejo-runner.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "We contact Forĝejo over tailscale, but services.tailscale.enable != true.";
      }
    ];

    age.secrets.act-runner.file = "${self.inputs.secrets}/act-runner.age";

    services.gitea-actions-runner.instances = {
      primary = {
        enable = true;

        labels = [
          # provide a debian base with nodejs for actions
          "debian-latest:docker://node:18-bullseye"
          # fake the ubuntu name, because node provides no ubuntu builds
          "ubuntu-latest:docker://node:18-bullseye"
          # provide native execution on the host
          "native:host"
        ];

        name = "${config.networking.hostName}-primary";
        settings.container.network = "host";
        tokenFile = config.age.secrets.act-runner.path;
        url = "http://mauville:3000";
      };

      secondary = {
        enable = true;

        labels = [
          # provide a debian base with nodejs for actions
          "debian-latest:docker://node:18-bullseye"
          # fake the ubuntu name, because node provides no ubuntu builds
          "ubuntu-latest:docker://node:18-bullseye"
          # provide native execution on the host
          "native:host"
        ];

        name = "${config.networking.hostName}-secondary";
        settings.container.network = "host";
        tokenFile = config.age.secrets.act-runner.path;
        url = "http://mauville:3000";
      };
    };
  };
}
