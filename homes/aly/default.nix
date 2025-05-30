{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  imports = [self.homeManagerModules.default];

  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs; [
          curl
          rclone
          wget
        ];

        username = "aly";
      };

      programs.home-manager.enable = true;
      xdg.enable = true;
      # stylix.targets.firefox.profileNames = ["default"];

      myHome = {
        aly = {
          profiles.mail.enable = true;

          programs = {
            awscli.enable = true;
            git.enable = true;
            halloy.enable = true;
            helix.enable = true;
            thunderbird.enable = true;
            vesktop.enable = true;
            vsCode.enable = true;
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
        aly = {
          desktop.hyprland.enable = config.wayland.windowManager.hyprland.enable;

          programs = {
            chromium.enable = true;
            rbw.enable = true;
          };
        };

        profiles.defaultApps = {
          enable = true;
          editor.package = config.programs.vscode.package;
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
