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
        xdg.userDirs.music = "/mnt/Media/Music";
        alyraffauf = {
          desktop = {
            hyprland.autoSuspend = false;
            sway.autoSuspend = false;
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
