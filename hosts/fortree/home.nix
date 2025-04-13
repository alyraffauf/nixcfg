{self, ...}: {
  home-manager.users.aly = {
    config,
    lib,
    ...
  }: {
    imports = [self.homeManagerModules.aly-darwin];

    age.secrets = {
      syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/fortree/cert.age";
      syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/fortree/key.age";
    };

    home.stateVersion = "25.05";
    launchd.agents.syncthing.config.EnvironmentVariables.HOME = config.home.homeDirectory;

    services.syncthing = let
      devices = config.mySnippets.syncthing.devices;

      folders = lib.mkMerge [
        config.mySnippets.syncthing.folders
        {
          "music" = {
            enable = lib.mkForce false;
            path = "/Users/aly/Music";
          };

          "roms".enable = lib.mkForce false;
          "screenshots".enable = lib.mkForce false;
          "sync".path = lib.mkForce "/Users/aly/Sync";
        }
      ];
    in {
      enable = true;
      cert = config.age.secrets.syncthingCert.path;
      key = config.age.secrets.syncthingKey.path;

      settings = {
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1;
        };

        inherit devices folders;
      };
    };
  };
}
