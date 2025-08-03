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
      self.inputs.fontix.homeModules.default
    ];

    age.secrets = {
      syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/fortree/cert.age";
      syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/fortree/key.age";
    };

    home.stateVersion = "25.05";
    launchd.agents.syncthing.config.EnvironmentVariables.HOME = config.home.homeDirectory;

    programs = {
      ghostty.settings.theme = "catppuccin-macchiato";

      zed-editor.userSettings = {
        "icon-theme" = "Catppuccin Macchiato";
        "theme" = "Catppuccin Macchiato - No Italics";
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

    fontix = {
      fonts = {
        monospace = {
          name = "CaskaydiaCove Nerd Font";
          package = pkgs.nerd-fonts.caskaydia-cove;
        };

        sansSerif = {
          name = "UbuntuSans Nerd Font";
          package = pkgs.nerd-fonts.ubuntu-sans;
        };

        serif = {
          name = "Source Serif Pro";
          package = pkgs.source-serif-pro;
        };
      };

      sizes = {
        applications = 11;
        desktop = 10;
      };

      zed-editor.enable = true;
      ghostty.enable = true;
      halloy.enable = true;
      font-packages.enable = true;
      fontconfig.enable = true;
    };
  };
}
