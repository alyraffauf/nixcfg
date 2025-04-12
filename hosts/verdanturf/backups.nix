{
  config,
  pkgs,
  ...
}: {
  services.restic.backups = let
    defaults = {
      extraBackupArgs = [
        "--cleanup-cache"
        "--compression max"
        "--no-scan"
      ];

      inhibitsSleep = true;
      initialize = true;
      passwordFile = config.age.secrets.restic-passwd.path;

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];

      rcloneConfigFile = config.age.secrets.rclone-b2.path;

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "2h";
      };
    };
  in {
    couchdb =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start couchdb";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop couchdb";
        paths = ["/var/lib/couchdb"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/couchdb";
      };

    pds =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start pds";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop pds";
        paths = ["/var/lib/pds"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/pds";
      };

    vaultwarden =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start vaultwarden";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop vaultwarden";
        paths = ["/var/lib/vaultwarden"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/vaultwarden";
      };
  };
}
