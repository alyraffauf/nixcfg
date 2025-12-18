{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.fontix.homeModules.default
    self.inputs.safari.homeModules.default
  ];

  config = lib.mkMerge [
    {
      home = {
        packages = [
          pkgs.rclone
        ];

        username = "aly";
      };

      programs = {
        bash.enable = true;
        home-manager.enable = true;
      };

      xdg.enable = true;

      fontix = {
        fonts = {
          monospace = {
            name = "CaskaydiaCove Nerd Font";
            package = pkgs.nerd-fonts.caskaydia-cove;
          };

          sansSerif =
            if pkgs.stdenv.isLinux
            then {
              name = "Adwaita Sans";
              package = pkgs.adwaita-fonts;
            }
            else {
              name = "UbuntuSans Nerd Font";
              package = pkgs.nerd-fonts.ubuntu-sans;
            };

          serif = {
            name = "Source Serif Pro";
            package = pkgs.source-serif-pro;
          };
        };

        sizes = {
          applications = 10;
          desktop = 10;
        };

        font-packages.enable = true;
        fontconfig.enable = true;
        ghostty.enable = true;
        gnome.enable = lib.mkIf pkgs.stdenv.isLinux true;
        gtk.enable = lib.mkIf pkgs.stdenv.isLinux true;
        halloy.enable = true;
        zed-editor.enable = true;
      };

      safari = {
        enable = true;
        fish.enable = true;
      };

      myHome = {
        aly.programs = {
          git.enable = true;
          ssh.enable = true;
          vesktop.enable = true;
          zed-editor.enable = true;
        };

        programs.ghostty.enable = true;
      };
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      home = {
        homeDirectory = "/Users/aly";
        shellAliases."docker" = "podman";
      };

      myHome.aly.desktop.macos.enable = true;
    })

    (lib.mkIf pkgs.stdenv.isLinux {
      gtk.gtk3.bookmarks = lib.mkAfter [
        "file://${config.home.homeDirectory}/sync"
      ];

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs;
          [
            cider-2
            google-chrome
            obsidian
            plexamp
            signal-desktop-bin
            todoist-electron
          ]
          ++ [
            (pkgs.writeShellScriptBin "aws-cvpn" ''
              exec ${self.inputs.aws-cvpn-client.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/aws-start-vpn.sh "$@"
            '')
          ];

        stateVersion = "25.11";
        username = "aly";
      };
    })
  ];
}
