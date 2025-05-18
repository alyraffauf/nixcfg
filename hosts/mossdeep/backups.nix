{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
    pds =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start pds";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop pds";
        paths = ["/var/lib/pds"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/pds";
      };
  };
}
