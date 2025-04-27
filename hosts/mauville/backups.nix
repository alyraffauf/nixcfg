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
        paths = ["/var/lib/ombi"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/ombi";
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

    syncthing-sync =
      config.mySnippets.restic
      // {
        paths = ["/home/aly/sync"];
        repository = "rclone:b2:aly-backups/syncthing/sync";
      };
  };
}
