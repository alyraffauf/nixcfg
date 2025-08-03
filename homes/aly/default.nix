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
  ];

  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs;
          [
            rclone
          ]
          ++ [
            self.inputs.nynx.packages.${pkgs.system}.nynx
          ];

        username = "aly";
      };

      programs.home-manager.enable = true;
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
              name = "Adwaita";
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
          applications = 11;
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

      myHome = {
        aly = {
          profiles.mail.enable = true;

          programs = {
            awscli.enable = true;
            git.enable = true;
            halloy.enable = true;
            helix.enable = true;
            ssh.enable = true;
            thunderbird.enable = true;
            vesktop.enable = true;
            vsCode.enable = true;
            zed-editor.enable = true;
            zen.enable = true;
          };
        };

        profiles.shell.enable = true;

        programs = {
          fastfetch.enable = true;
          ghostty.enable = true;
        };
      };
    }

    (lib.mkIf pkgs.stdenv.isDarwin {
      home = {
        homeDirectory = "/Users/aly";
        shellAliases."docker" = "podman";
      };

      myHome = {
        aly.desktop.macos.enable = true;
        services.raycast.enable = true;
      };
    })

    (lib.mkIf pkgs.stdenv.isLinux {
      gtk.gtk3.bookmarks = lib.mkAfter [
        "file://${config.home.homeDirectory}/sync"
      ];

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          bitwarden-desktop
          nicotine-plus
          obsidian
          plexamp
          protonvpn-gui
          signal-desktop-bin
        ];

        stateVersion = "25.05";
        username = "aly";
      };

      systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.

      myHome = {
        aly.programs = {
          chromium.enable = true;
          rbw.enable = true;
        };

        profiles.defaultApps = {
          enable = true;
          editor.package = config.programs.zed-editor.package;
          terminal.package = config.programs.ghostty.package;

          webBrowser = {
            exec = lib.getExe config.programs.zen-browser.finalPackage;
            package = config.programs.zen-browser.finalPackage;
          };
        };
      };
    })
  ];
}
