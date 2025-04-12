{
  config,
  pkgs,
  ...
}: let
  mediaDirectory = "/mnt/Media";
in {
  services.restic.backups = let
    defaults = {
      extraBackupArgs = [
        "--cleanup-cache"
        "--compression max"
        "--no-scan"
      ];

      inhibitsSleep = true;
      initialize = true;
      passwordFile = config.age.secrets.restic-passwd.path;

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];

      rcloneConfigFile = config.age.secrets.rclone-b2.path;

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "2h";
      };
    };
  in {
    audiobookshelf =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start audiobookshelf";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop audiobookshelf";
        paths = ["/var/lib/audiobookshelf"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/audiobookshelf";
      };

    immich =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start immich-server";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop immich-server";

        paths = [
          "${mediaDirectory}/Pictures/library"
          "${mediaDirectory}/Pictures/profile"
          "${mediaDirectory}/Pictures/upload"
          "${mediaDirectory}/Pictures/backups"
        ];

        repository = "rclone:b2:aly-backups/${config.networking.hostName}/immich";
      };

    lidarr =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start lidarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop lidarr";
        paths = ["/var/lib/lidarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/lidarr";
      };

    ombi =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start ombi";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop ombi";
        paths = ["/var/lib/ombi"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/ombi";
      };

    prowlarr =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start prowlarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop prowlarr";
        paths = ["/var/lib/prowlarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/prowlarr";
      };

    plex =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start plex";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop plex";
        paths = ["/var/lib/plex"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/plex";
      };

    radarr =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start radarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop radarr";
        paths = ["/var/lib/radarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/radarr";
      };

    readarr =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start readarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop readarr";
        paths = ["/var/lib/readarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/readarr";
      };

    sonarr =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start sonarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop sonarr";
        paths = ["/var/lib/sonarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/sonarr";
      };

    syncthing-sync =
      defaults
      // {
        paths = ["/home/aly/sync"];
        repository = "rclone:b2:aly-backups/syncthing/sync";
      };
  };
}
