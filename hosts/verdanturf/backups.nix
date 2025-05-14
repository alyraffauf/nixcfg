{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = {
    couchdb =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start couchdb";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop couchdb";
        paths = ["/var/lib/couchdb"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/couchdb";
      };

    pds =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start pds";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop pds";
        paths = ["/var/lib/pds"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/pds";
      };

    vaultwarden =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start vaultwarden";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop vaultwarden";
        paths = ["/var/lib/vaultwarden"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/vaultwarden";
      };
  };
}
