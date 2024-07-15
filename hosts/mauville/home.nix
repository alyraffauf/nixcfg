{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        xdg.userDirs.music = "/mnt/Media/Music";

        ar.home.desktop.hyprland = {
          autoSuspend = false;
          monitors = ["desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.25,vrr,2"];
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

        timers.backblaze-sync = {
          Install.WantedBy = ["timers.target"];
          Timer.OnCalendar = "*-*-* 03:00:00";
          Unit.Description = "Daily backups to Backblaze.";
        };
      };
    };
  };
}
