{
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager.sway.config.output = {"LG Electronics LG ULTRAWIDE 311NTAB5M720".scale = "1.25";};
        xdg.userDirs.music = "/mnt/Media/Music";

        ar.home = {
          desktop = {
            autoSuspend = false;
            hyprland.monitors = ["desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.25,vrr,2"];
          };

          theme = {
            colors = lib.mkForce {
              text = "#575279";
              background = "#fffaf3";
              primary = "#286983";
              secondary = "#ea9d34";
              inactive = "#393552";
              shadow = "#232136";
            };

            darkMode = false;
          };
        };
      }
    ];

    users.aly = lib.mkForce {
      imports = [self.homeManagerModules.aly];

      systemd.user = {
        services.backblaze-sync = {
          Unit.Description = "Backup to Backblaze.";

          Service.ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
            declare -A backups
            backups=(
              ['/home/aly/pics/camera']="b2://aly-camera"
              ['/home/aly/sync']="b2://aly-sync"
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

        timers.backblaze-sync = {
          Install.WantedBy = ["timers.target"];
          Timer.OnCalendar = "*-*-* 03:00:00";
          Unit.Description = "Daily backups to Backblaze.";
        };
      };
    };
  };
}
