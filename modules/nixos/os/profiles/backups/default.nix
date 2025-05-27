{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.backups = {
    enable = lib.mkEnableOption "automatically back up enabled services to b2";
  };

  config = lib.mkIf config.myNixOS.profiles.backups.enable {
    age.secrets = {
      rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
      restic-passwd.file = "${self.inputs.secrets}/restic-password.age";
    };

    services.restic.backups = {
      bazarr = lib.mkIf config.services.bazarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start bazarr";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop bazarr";
          paths = [config.services.bazarr.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/bazarr";
        }
      );

      lidarr = lib.mkIf config.services.lidarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start lidarr";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop lidarr";
          paths = [config.services.lidarr.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/lidarr";
        }
      );

      pds = lib.mkIf config.services.pds.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start pds";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop pds";
          paths = [config.services.pds.settings.PDS_DATA_DIRECTORY];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/pds";
        }
      );

      prowlarr = lib.mkIf config.services.prowlarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start prowlarr";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop prowlarr";
          paths = ["config.services.prowlarr.dataDir"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/prowlarr";
        }
      );

      radarr = lib.mkIf config.services.radarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start radarr";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop radarr";
          paths = [config.services.radarr.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/radarr";
        }
      );

      readarr = lib.mkIf config.services.readarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start readarr";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop readarr";
          paths = [config.services.readarr.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/readarr";
        }
      );

      sonarr = lib.mkIf config.services.sonarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start sonarr";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop sonarr";
          paths = [config.services.sonarr.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/sonarr";
        }
      );
    };
  };
}
