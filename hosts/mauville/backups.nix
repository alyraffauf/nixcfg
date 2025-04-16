{
  config,
  pkgs,
  ...
}: let
  mediaDirectory = "/mnt/Media";
in {
  services.restic.backups = {
    audiobookshelf =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start audiobookshelf";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop audiobookshelf";
        paths = ["/var/lib/audiobookshelf"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/audiobookshelf";
      };

    immich =
      config.mySnippets.restic
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
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start lidarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop lidarr";
        paths = ["/var/lib/lidarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/lidarr";
      };

    ombi =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start ombi";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop ombi";
        paths = ["/var/lib/ombi"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/ombi";
      };

    prowlarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start prowlarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop prowlarr";
        paths = ["/var/lib/prowlarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/prowlarr";
      };

    plex =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start plex";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop plex";
        exclude = ["/var/lib/plex/Plex Media Server/Plug-in Support/Databases"];
        paths = ["/var/lib/plex"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/plex";
      };

    radarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start radarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop radarr";
        paths = ["/var/lib/radarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/radarr";
      };

    readarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start readarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop readarr";
        paths = ["/var/lib/readarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/readarr";
      };

    sonarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start sonarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop sonarr";
        paths = ["/var/lib/sonarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/sonarr";
      };

    syncthing-sync =
      config.mySnippets.restic
      // {
        paths = ["/home/aly/sync"];
        repository = "rclone:b2:aly-backups/syncthing/sync";
      };

    transmission =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start transmission";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop transmission";

        exclude = [
          "/var/lib/transmission/.incomplete"
          "/var/lib/transmission/Downloads"
          "/var/lib/transmission/watchdir"
        ];

        paths = ["/var/lib/transmission"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/transmission";
      };
  };
}
