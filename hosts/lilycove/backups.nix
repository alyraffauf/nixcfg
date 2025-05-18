{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
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

    ombi =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start ombi";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop ombi";
        paths = [config.services.ombi.dataDir];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/ombi";
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

    # syncthing-sync =
    #   config.mySnippets.restic
    #   // {
    #     paths = ["/home/aly/sync"];
    #     repository = "rclone:b2:aly-backups/syncthing/sync";
    #   };

    tautulli =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start tautulli";
        backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop tautulli'';
        paths = ["/var/lib/plexpy"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/tautulli";
      };
  };
}
