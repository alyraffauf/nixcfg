{
  config,
  lib,
  pkgs,
  ...
}: let
  backupDestination = "rclone:b2:aly-backups/${config.networking.hostName}";
  mkRepo = service: "${backupDestination}/${service}";
  stop = service: "${pkgs.systemd}/bin/systemctl stop ${service}";
  start = service: "${pkgs.systemd}/bin/systemctl start ${service}";
in {
  options.myNixOS.profiles.backups = {
    enable = lib.mkEnableOption "automatically back up enabled services to b2";
  };

  config = lib.mkIf config.myNixOS.profiles.backups.enable {
    services.restic.backups = {
      bazarr = lib.mkIf config.services.bazarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "bazarr";
          backupPrepareCommand = stop "bazarr";
          paths = [config.services.bazarr.dataDir];
          repository = mkRepo "bazarr";
        }
      );

      couchdb = lib.mkIf config.services.couchdb.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "couchdb";
          backupPrepareCommand = stop "couchdb";
          paths = [config.services.couchdb.databaseDir];
          repository = mkRepo "couchdb";
        }
      );

      forgejo = lib.mkIf config.services.forgejo.enable (
        config.mySnippets.restic
        // {
          paths = [config.services.forgejo.stateDir];
          repository = mkRepo "forgejo";
        }
      );

      homebridge = lib.mkIf config.myNixOS.services.homebridge.enable (
        config.mySnippets.restic
        // {
          paths = [config.myNixOS.services.homebridge.stateDir];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/homebridge";
        }
      );

      immich = lib.mkIf config.services.immich.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "immich-server";
          backupPrepareCommand = stop "immich-server";

          paths = [
            "${config.services.immich.mediaLocation}/library"
            "${config.services.immich.mediaLocation}/profile"
            "${config.services.immich.mediaLocation}/upload"
            "${config.services.immich.mediaLocation}/backups"
          ];

          repository = mkRepo "immich";
        }
      );

      jellyfin = lib.mkIf config.services.jellyfin.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "jellyfin";
          backupPrepareCommand = stop "jellyfin";
          paths = [config.services.jellyfin.dataDir];
          repository = mkRepo "jellyfin";
        }
      );

      lidarr = lib.mkIf config.services.lidarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "lidarr";
          backupPrepareCommand = stop "lidarr";
          paths = [config.services.lidarr.dataDir];
          repository = mkRepo "lidarr";
        }
      );

      ombi = lib.mkIf config.services.ombi.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "ombi";
          backupPrepareCommand = stop "ombi";
          paths = [config.services.ombi.dataDir];
          repository = mkRepo "ombi";
        }
      );

      pds = lib.mkIf config.services.pds.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "pds";
          backupPrepareCommand = stop "pds";
          paths = [config.services.pds.settings.PDS_DATA_DIRECTORY];
          repository = mkRepo "pds";
        }
      );

      plex = lib.mkIf config.services.plex.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "plex";
          backupPrepareCommand = stop "plex";
          exclude = ["${config.services.plex.dataDir}/Plex Media Server/Plug-in Support/Databases"];
          paths = [config.services.plex.dataDir];
          repository = mkRepo "plex";
        }
      );

      postgresql = lib.mkIf config.services.postgresql.enable (
        config.mySnippets.restic
        // {
          paths = [config.services.postgresql.dataDir];
          repository = mkRepo "postgresql";
        }
      );

      prowlarr = lib.mkIf config.services.prowlarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "prowlarr";
          backupPrepareCommand = stop "prowlarr";
          paths = [config.services.prowlarr.dataDir];
          repository = mkRepo "prowlarr";
        }
      );

      qbittorrent = lib.mkIf config.myNixOS.services.qbittorrent.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "qbittorrent";
          backupPrepareCommand = stop "qbittorrent";
          paths = [config.myNixOS.services.qbittorrent.dataDir];
          repository = mkRepo "qbittorrent";
        }
      );

      radarr = lib.mkIf config.services.radarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "radarr";
          backupPrepareCommand = stop "radarr";
          paths = [config.services.radarr.dataDir];
          repository = mkRepo "radarr";
        }
      );

      readarr = lib.mkIf config.services.readarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "readarr";
          backupPrepareCommand = stop "readarr";
          paths = [config.services.readarr.dataDir];
          repository = mkRepo "readarr";
        }
      );

      sonarr = lib.mkIf config.services.sonarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "sonarr";
          backupPrepareCommand = stop "sonarr";
          paths = [config.services.sonarr.dataDir];
          repository = mkRepo "sonarr";
        }
      );

      tautulli = lib.mkIf config.services.tautulli.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "tautulli";
          backupPrepareCommand = stop "tautulli";
          paths = [config.services.tautulli.dataDir];
          repository = mkRepo "tautulli";
        }
      );

      uptime-kuma = lib.mkIf config.services.uptime-kuma.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "uptime-kuma";
          backupPrepareCommand = stop "uptime-kuma";
          paths = ["/var/lib/uptime-kuma"];
          repository = mkRepo "uptime-kuma";
        }
      );

      vaultwarden = lib.mkIf config.services.vaultwarden.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "vaultwarden";
          backupPrepareCommand = stop "vaultwarden";
          paths = ["/var/lib/vaultwarden"];
          repository = mkRepo "vaultwarden";
        }
      );
    };
  };
}
