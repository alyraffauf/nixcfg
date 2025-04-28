{
  config,
  lib,
  self,
  ...
}: {
  options.myNixOS.profiles.forgejo-runner.enable = lib.mkEnableOption "3 forĝejo runners";
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
          "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
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
          "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
          "native:host"
        ];

        name = "${config.networking.hostName}-secondary";
        settings.container.network = "host";
        tokenFile = config.age.secrets.act-runner.path;
        url = "http://mauville:3000";
      };

      tertiary = {
        enable = true;

        labels = [
          "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
          "native:host"
        ];

        name = "${config.networking.hostName}-tertiary";
        settings.container.network = "host";
        tokenFile = config.age.secrets.act-runner.path;
        url = "http://mauville:3000";
      };
    };
  };
}
