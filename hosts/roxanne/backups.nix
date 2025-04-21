{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
    tautulli =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start tautulli";
        backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop tautulli'';
        paths = ["/var/lib/plexpy"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/tautulli";
      };

    uptime-kuma =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start uptime-kuma";
        backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop uptime-kuma'';
        paths = ["/var/lib/uptime-kuma"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/uptime-kuma";
      };
  };
}
