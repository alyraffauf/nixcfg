{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
    bazarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start bazarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop bazarr";
        paths = ["/var/lib/bazarr"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/bazarr";
      };

    dizquetv =
      config.mySnippets.restic
      // {
        paths = ["/mnt/Data/dizquetv"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/dizquetv";
      };

    immich =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start immich-server";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop immich-server";

        paths = [
          "${config.services.immich.mediaLocation}/library"
          "${config.services.immich.mediaLocation}/profile"
          "${config.services.immich.mediaLocation}/upload"
          "${config.services.immich.mediaLocation}/backups"
        ];

        repository = "rclone:b2:aly-backups/${config.networking.hostName}/immich";
      };

    lidarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start lidarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop lidarr";
        paths = [config.services.lidarr.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/lidarr";
      };

    ombi =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start ombi";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop ombi";
        paths = [config.services.ombi.dataDir];
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
        exclude = ["${config.services.plex.dataDir}/Plex Media Server/Plug-in Support/Databases"];
        paths = [config.services.plex.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/plex";
      };

    qbittorrent =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start qbittorrent";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop qbittorrent";
        paths = [config.myNixOS.services.qbittorrent.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/qbittorrent";
      };

    radarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start radarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop radarr";
        paths = [config.services.radarr.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/radarr";
      };

    readarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start readarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop readarr";
        paths = [config.services.readarr.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/readarr";
      };

    sonarr =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start sonarr";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop sonarr";
        paths = [config.services.sonarr.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/sonarr";
      };

    # syncthing-sync =
    #   config.mySnippets.restic
    #   // {
    #     paths = ["/home/aly/sync"];
    #     repository = "rclone:b2:aly-backups/syncthing/sync";
    #   };

    tubesync =
      config.mySnippets.restic
      // {
        paths = ["/mnt/Data/tubesync"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/tubesync";
      };

    transmission =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start transmission";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop transmission";

        exclude = [
          "${config.services.transmission.home}/.incomplete"
          "${config.services.transmission.home}/Downloads"
          "${config.services.transmission.home}/watchdir"
        ];

        paths = [config.services.transmission.home];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/transmission";
      };
  };
}
