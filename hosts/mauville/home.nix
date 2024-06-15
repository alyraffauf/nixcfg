{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        programs.vscode.userSettings = {
          "workbench.colorTheme" = lib.mkForce "Catppuccin Macchiato";
          "workbench.iconTheme" = lib.mkForce "catppuccin-macchiato";
        };

        xdg.userDirs.music = "/mnt/Media/Music";
        alyraffauf = {
          desktop = {
            hyprland.autoSuspend = false;
            sway.autoSuspend = false;
          };
          theme = lib.mkForce {
            enable = true;
            gtk = {
              name = "Catppuccin-Macchiato-Compact-Mauve-Dark";
              package = pkgs.catppuccin-gtk.override {
                accents = ["mauve"];
                size = "compact";
                variant = "macchiato";
                tweaks = ["normal"];
              };
            };
            qt = {
              name = "Catppuccin-Macchiato-Mauve";
              package = pkgs.catppuccin-kvantum.override {
                accent = "Mauve";
                variant = "Macchiato";
              };
            };
            iconTheme = {
              name = "Papirus-Light";
              package = pkgs.catppuccin-papirus-folders.override {
                flavor = "macchiato";
                accent = "mauve";
              };
            };
            cursorTheme = {
              name = "Catppuccin-Macchiato-Dark-Cursors";
              size = 32;
              package = pkgs.catppuccin-cursors.macchiatoDark;
            };
            colors = {
              preferDark = true;
              text = "#4c4f69";
              background = "#eff1f5";
              primary = "#8839ef";
              secondary = "#04a5e5";
              inactive = "#626880";
              shadow = "#1A1A1A";
            };
          };
        };
      }
    ];

    users.aly = {
      imports = [../../homes/aly.nix];
      systemd.user = {
        services.backblaze-sync = {
          Unit = {
            Description = "Backup to Backblaze.";
          };
          Service = {
            ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
              declare -A backups
              backups=(
                ['/home/aly/pics/camera']="b2://aly-camera"
                ['/home/aly/sync']="b2://aly-sync"
                ['/mnt/Archive/Archive']="b2://aly-archive"
                ['/mnt/Media/Audiobooks']="b2://aly-audiobooks"
                ['/mnt/Media/Music']="b2://aly-music"
              )
              # Recursively backup folders to B2 with sanity checks.
              for folder in "''${!backups[@]}"; do
                if [ -d "$folder" ] && [ "$(ls -A "$folder")" ]; then
                  ${lib.getExe pkgs.backblaze-b2} sync --delete $folder ''${backups[$folder]}
                else
                  echo "$folder does not exist or is empty."
                  exit 1
                fi
              done
            ''}";
          };
        };
        timers.backblaze-sync = {
          Unit = {
            Description = "Daily backups to Backblaze.";
          };
          Install = {
            WantedBy = ["timers.target"];
          };
          Timer = {
            OnCalendar = "*-*-* 03:00:00";
          };
        };
      };
    };
    users.dustin = import ../../homes/dustin.nix;
  };
}
