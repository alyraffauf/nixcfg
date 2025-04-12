{config, ...}: {
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
    homebridge =
      defaults
      // {
        paths = ["/var/lib/homebridge"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/homebridge";
      };
  };
}
