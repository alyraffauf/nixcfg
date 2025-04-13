{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
    jellyfin =
      config.mySnippets.resticDefaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start jellyfin";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop jellyfin";
        paths = ["/var/lib/jellyfin"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/jellyfin";
      };
  };
}
