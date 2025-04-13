{
  config,
  lib,
  ...
}: {
  options = {
    mySnippets.restic = lib.mkOption {
      type = lib.types.attrs;
      description = "Default restic backup settings shared across backup jobs.";

      default = {
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
    };
  };
}
