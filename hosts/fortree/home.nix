{self, ...}: {
  home-manager.users.aly = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.homeConfigurations.aly
      self.homeModules.snippets
      self.inputs.agenix.homeManagerModules.default
      self.inputs.catppuccin.homeModules.catppuccin
    ];

    age.secrets = {
      syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/fortree/cert.age";
      syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/fortree/key.age";
    };

    home.stateVersion = "25.05";
    launchd.agents.syncthing.config.EnvironmentVariables.HOME = config.home.homeDirectory;

    programs.vscode.profiles.default = {
      extensions = [
        pkgs.vscode-extensions.catppuccin.catppuccin-vsc
        pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.iconTheme" = "catppuccin-macchiato";
      };
    };

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

    catppuccin = {
      flavor = "macchiato";
      helix.enable = true;
      ghostty.enable = true;
      vesktop.enable = true;
      # vscode.profiles.default.enable = true;

      zed = {
        enable = true;
        icons.enable = true;
        italics = false;
      };

      zellij.enable = true;
    };
  };
}
