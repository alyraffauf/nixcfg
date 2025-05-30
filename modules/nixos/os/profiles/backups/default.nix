{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.backups = {
    enable = lib.mkEnableOption "automatically back up enabled services to b2";
  };

  config = lib.mkIf config.myNixOS.profiles.backups.enable {
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

      couchdb = lib.mkIf config.services.couchdb.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start couchdb";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop couchdb";
          paths = [config.services.couchdb.databaseDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/couchdb";
        }
      );

      immich = lib.mkIf config.services.immich.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start immich-server";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop immich-server";

          paths = [
            "${config.services.immich.mediaLocation}/library"
            "${config.services.immich.mediaLocation}/profile"
            "${config.services.immich.mediaLocation}/upload"
            "${config.services.immich.mediaLocation}/backups"
          ];

          repository = "rclone:b2:aly-backups/${config.networking.hostName}/immich";
        }
      );

      jellyfin = lib.mkIf config.services.jellyfin.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start jellyfin";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop jellyfin";
          paths = [config.services.jellyfin.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/jellyfin";
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

      ombi = lib.mkIf config.services.ombi.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start ombi";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop ombi";
          paths = [config.services.ombi.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/ombi";
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

      plex = lib.mkIf config.services.plex.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start plex";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop plex";
          exclude = ["${config.services.plex.dataDir}/Plex Media Server/Plug-in Support/Databases"];
          paths = [config.services.plex.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/plex";
        }
      );

      postgresql = lib.mkIf config.services.postgresql.enable (
        config.mySnippets.restic
        // {
          paths = [config.services.postgresql.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/postgresql";
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

      qbittorrent = lib.mkIf config.myNixOS.services.qbittorrent.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start qbittorrent";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop qbittorrent";
          paths = [config.myNixOS.services.qbittorrent.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/qbittorrent";
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

      tautulli = lib.mkIf config.services.tautulli.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start tautulli";
          backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop tautulli'';
          paths = [config.services.tautulli.dataDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/tautulli";
        }
      );

      uptime-kuma = lib.mkIf config.services.uptime-kuma.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start uptime-kuma";
          backupPrepareCommand = ''${pkgs.systemd}/bin/systemctl stop uptime-kuma'';
          paths = ["/var/lib/uptime-kuma"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/uptime-kuma";
        }
      );

      vaultwarden = lib.mkIf config.services.vaultwarden.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start vaultwarden";
          backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop vaultwarden";
          paths = ["/var/lib/vaultwarden"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/vaultwarden";
        }
      );
    };
  };
}
