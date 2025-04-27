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

    syncthing-sync =
      config.mySnippets.restic
      // {
        paths = ["/home/aly/sync"];
        repository = "rclone:b2:aly-backups/syncthing/sync";
      };
  };
}
