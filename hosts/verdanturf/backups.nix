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

    uptime-kuma =
      config.mySnippets.restic
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start uptime-kuma";
        backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop uptime-kuma'';
        paths = ["/var/lib/uptime-kuma"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/uptime-kuma";
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
