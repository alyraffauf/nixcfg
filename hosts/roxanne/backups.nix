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
    uptime-kuma =
      defaults
      // {
        backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start uptime-kuma";
        backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop uptime-kuma'';
        paths = ["/var/lib/uptime-kuma"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/uptime-kuma";
      };
  };
}
