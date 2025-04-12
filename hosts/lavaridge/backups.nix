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
    jellyfin =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start jellyfin";
        backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop jellyfin";
        paths = ["/var/lib/jellyfin"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/jellyfin";
      };
  };
}
