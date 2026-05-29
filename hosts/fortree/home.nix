{self, ...}: {
  home-manager.users.aly = {
    config,
    lib,
    ...
  }: {
    imports = [
      self.homeModules.default
      self.inputs.snippets.homeModules.snippets
    ];

    sops.secrets = {
      syncthingCert = {
        sopsFile = ../../secrets/syncthing/fortree.yaml;
        key = "cert";
      };

      syncthingKey = {
        sopsFile = ../../secrets/syncthing/fortree.yaml;
        key = "key";
      };
    };

    home = {
      homeDirectory = "/Users/aly";
      stateVersion = "25.11";
      username = "aly";
    };

    launchd.agents.syncthing.config.EnvironmentVariables.HOME = config.home.homeDirectory;

    services.syncthing = let
      inherit (config.mySnippets.syncthing) devices;

      folders = lib.mkMerge [
        config.mySnippets.syncthing.folders
        {
          "music" = {
            enable = lib.mkForce false;
            path = "/Users/aly/Music";
          };

          "roms" = {
            enable = lib.mkForce false;
            path = "/Users/aly/ROMs";
          };

          "screenshots".enable = lib.mkForce false;
          "sync".path = lib.mkForce "/Users/aly/Sync";
        }
      ];
    in {
      enable = true;
      cert = config.sops.secrets.syncthingCert.path;
      key = config.sops.secrets.syncthingKey.path;

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
