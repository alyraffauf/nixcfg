# Beelink S12 Pro mini PC with Intel N100, 16GB RAM, 500GB SSD + 2TB SSD.
{
  config,
  pkgs,
  self,
  ...
}: let
  mediaDirectory = "/mnt/Media";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    self.nixosModules.hardware-beelink-mini-s12pro
    self.nixosModules.locale-en-us
  ];

  environment.systemPackages = [pkgs.rclone];

  fileSystems = {
    "${mediaDirectory}/Audiobooks" = {
      device = "b2:aly-audiobooks";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
        "vfs-cache-max-size=10G" # Cache up to 100GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=512M" # Preload 512MB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };

    "${mediaDirectory}/Movies" = {
      device = "b2:aly-movies";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
        "vfs-cache-max-size=100G" # Cache up to 100GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=512M" # Preload 512MB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };

    "${mediaDirectory}/Shows" = {
      device = "b2:aly-shows";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
        "vfs-cache-max-size=100G" # Cache up to 100GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=512M" # Preload 512MB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };
  };

  networking.hostName = "mauville";

  services = {
    restic.backups = let
      defaults = {
        inhibitsSleep = true;
        initialize = true;
        passwordFile = config.age.secrets.restic-passwd.path;

        pruneOpts = [
          "--keep-daily 5"
          "--keep-weekly 4"
          "--keep-monthly 12"
          "--compression max"
        ];

        rcloneConfigFile = config.age.secrets.rclone-b2.path;

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "2h";
        };
      };
    in {
      audiobookshelf =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start audiobookshelf
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop audiobookshelf
          '';

          paths = ["/var/lib/audiobookshelf"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/audiobookshelf";
        };

      immich =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start immich-server
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop immich-server
          '';

          paths = [
            "${mediaDirectory}/Pictures/library"
            "${mediaDirectory}/Pictures/profile"
            "${mediaDirectory}/Pictures/upload"
            "${mediaDirectory}/Pictures/backups"
          ];

          repository = "rclone:b2:aly-backups/${config.networking.hostName}/immich";
        };

      plex =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start plex
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop plex
          '';

          paths = ["/var/lib/plex"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/plex";
        };

      radarr =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start radarr
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop radarr
          '';

          paths = ["/var/lib/radarr"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/radarr";
        };

      sonarr =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start sonarr
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop sonarr
          '';

          paths = ["/var/lib/sonarr"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/sonarr";
        };
    };

    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          security = "user";
          "map to guest" = "Bad User";
          "read raw" = "Yes";
          "write raw" = "Yes";
          "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
          "min receivefile size" = 16384;
          "use sendfile" = true;
          "aio read size" = 16384;
          "aio write size" = 16384;
        };

        Media = {
          "create mask" = "0755";
          "directory mask" = "0755";
          "force group" = "users";
          "force user" = "aly";
          "guest ok" = "yes";
          "read only" = "no";
          browseable = "yes";
          comment = "Media @ ${config.networking.hostName}";
          path = mediaDirectory;
        };
      };
    };
  };

  stylix = {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
  };

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "25.05";
  };

  time.timeZone = "America/New_York";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      server.enable = true;
      wifi.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        musicPath = "${mediaDirectory}/Music";
        syncMusic = true;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$SHPShqI2IpRE101Ey2ry/0$0mhW1f9LbVY02ifhJlP9XVImge9HOpf23s9i1JFLIt9";
  };
}
