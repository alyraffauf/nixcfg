{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        imports = [../../homeManagerModules];
        xdg.userDirs.music = "/mnt/Media/Music";
        alyraffauf.desktop.hyprland.autoSuspend = false;
        alyraffauf.desktop.sway.autoSuspend = false;
      }
    ];
    users.aly = {
      imports = [../../aly.nix];
      systemd.user = {
        services.backblaze-sync = {
          Unit = {
            Description = "Backup to Backblaze.";
            After = ["network.target"];
          };
          Install = {
            WantedBy = ["default.target"];
          };
          Service = {
            ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
              BACKBLAZE=${lib.getExe pkgs.backblaze-b2}

              $BACKBLAZE sync --delete /mnt/Media/Music b2://aly-music
              $BACKBLAZE sync --delete /mnt/Media/Audiobooks b2://aly-audiobooks
              $BACKBLAZE sync --delete /mnt/Archive/Archive b2://aly-archive

              $BACKBLAZE sync --delete /home/aly/sync b2://aly-sync
              $BACKBLAZE sync --delete /home/aly/pics/camera b2://aly-camera
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
    users.dustin = import ../../dustin.nix;
  };
}
