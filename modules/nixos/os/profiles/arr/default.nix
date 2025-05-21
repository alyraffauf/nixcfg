{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.arr = {
    enable = lib.mkEnableOption "*arr services";
    backup = lib.mkEnableOption "backup to b2";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib";
      description = "The directory where *arr stores its data files.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.myNixOS.profiles.arr.enable {
      # fileSystems."/var/lib/prowlarr" =
      #   lib.mkIf (config.myNixOS.profiles.arr.dataDir != "/var/lib")
      #   {
      #     device = "${config.myNixOS.profiles.arr.dataDir}/prowlarr";
      #     options = ["bind"];
      #   };

      services = {
        lidarr = {
          enable = true;
          dataDir = "${config.myNixOS.profiles.arr.dataDir}/lidarr/.config/Lidarr";
          openFirewall = true; # Port: 8686
        };

        prowlarr = {
          enable = true;
          dataDir = "${config.myNixOS.profiles.arr.dataDir}/prowlarr";
          openFirewall = true; # Port: 9696
        };

        radarr = {
          enable = true;
          dataDir = "${config.myNixOS.profiles.arr.dataDir}/radarr/.config/Radarr/";
          openFirewall = true; # Port: 7878
        };

        readarr = {
          enable = true;
          dataDir = "${config.myNixOS.profiles.arr.dataDir}/readarr/";
          openFirewall = true; # Port: 8787
        };

        sonarr = {
          enable = true;
          dataDir = "${config.myNixOS.profiles.arr.dataDir}/sonarr/.config/NzbDrone/";
          openFirewall = true; # Port: 8989
        };
      };

      myNixOS.services.bazarr = {
        enable = true;
        dataDir = "${config.myNixOS.profiles.arr.dataDir}/bazarr";
        openFirewall = true; # Port: 6767
      };

      systemd = {
        tmpfiles.rules = [
          "d ${config.myNixOS.services.bazarr.dataDir} 0755 bazarr bazarr"
          "d ${config.services.lidarr.dataDir} 0755 lidarr lidarr"
          "d ${config.services.radarr.dataDir} 0755 radarr radarr"
          "d ${config.services.readarr.dataDir} 0755 readarr readarr"
          "d ${config.services.sonarr.dataDir} 0755 sonarr sonarr"
        ];
      };
    })

    (lib.mkIf config.myNixOS.profiles.arr.backup {
      services.restic.backups = {
        bazarr =
          config.mySnippets.restic
          // {
            backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start bazarr";
            backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop bazarr";
            paths = [config.myNixOS.services.bazarr.dataDir];
            repository = "rclone:b2:aly-backups/${config.networking.hostName}/bazarr";
          };

        lidarr =
          config.mySnippets.restic
          // {
            backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start lidarr";
            backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop lidarr";
            paths = [config.services.lidarr.dataDir];
            repository = "rclone:b2:aly-backups/${config.networking.hostName}/lidarr";
          };

        prowlarr =
          config.mySnippets.restic
          // {
            backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start prowlarr";
            backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop prowlarr";
            paths = ["/var/lib/prowlarr"];
            repository = "rclone:b2:aly-backups/${config.networking.hostName}/prowlarr";
          };

        radarr =
          config.mySnippets.restic
          // {
            backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start radarr";
            backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop radarr";
            paths = [config.services.radarr.dataDir];
            repository = "rclone:b2:aly-backups/${config.networking.hostName}/radarr";
          };

        readarr =
          config.mySnippets.restic
          // {
            backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start readarr";
            backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop readarr";
            paths = [config.services.readarr.dataDir];
            repository = "rclone:b2:aly-backups/${config.networking.hostName}/readarr";
          };

        sonarr =
          config.mySnippets.restic
          // {
            backupCleanupCommand = "${pkgs.systemd}/bin/systemctl start sonarr";
            backupPrepareCommand = "${pkgs.systemd}/bin/systemctl stop sonarr";
            paths = [config.services.sonarr.dataDir];
            repository = "rclone:b2:aly-backups/${config.networking.hostName}/sonarr";
          };
      };
    })
  ];
}
