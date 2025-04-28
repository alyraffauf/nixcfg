{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
    audiobookshelf =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start audiobookshelf";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop audiobookshelf";
        paths = ["/var/lib/audiobookshelf"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/audiobookshelf";
      };

    syncthing-sync =
      config.mySnippets.restic
      // {
        paths = ["/home/aly/sync"];
        repository = "rclone:b2:aly-backups/syncthing/sync";
      };
  };
}
