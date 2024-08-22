{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager = {
    users.aly = lib.mkForce {
      imports = [
        self.homeManagerModules.default
        self.inputs.agenix.homeManagerModules.default
      ];

      age.secrets = {
        backblazeKeyId.file = ../../secrets/aly/backblaze/keyId.age;
        backblazeKey.file = ../../secrets/aly/backblaze/key.age;
      };

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          browsh
          curl
        ];

        stateVersion = "24.05";
        username = "aly";
      };

      programs = {
        git = {
          enable = true;
          lfs.enable = true;
          userName = "Aly Raffauf";
          userEmail = "aly@raffauflabs.com";

          extraConfig = {
            color.ui = true;
            github.user = "alyraffauf";
            push.autoSetupRemote = true;
          };
        };

        gitui.enable = true;
        helix.defaultEditor = true;
        home-manager.enable = true;

        rbw = {
          enable = true;

          settings = {
            email = "alyraffauf@fastmail.com";
            lock_timeout = 14400;
          };
        };
      };

      systemd.user.startServices = "legacy"; # Needed for auto-mounting agenix secrets.

      ar.home = {
        apps = {
          backblaze = {
            enable = true;
            keyIdFile = config.age.secrets.backblazeKeyId.path;
            keyFile = config.age.secrets.backblazeKey.path;
          };

          fastfetch.enable = true;
          helix.enable = true;
          shell.enable = true;
          tmux.enable = true;
          yazi.enable = true;
        };
      };
    };
  };
}
