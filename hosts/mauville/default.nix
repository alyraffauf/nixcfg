{
  config,
  pkgs,
  self,
  ...
}: let
  mediaDirectory = "/mnt/Media";
in {
  imports = [
    ./arr.nix
    ./backups.nix
    ./disko.nix
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    self.nixosModules.hardware-beelink-mini-s12pro
    self.nixosModules.locale-en-us
  ];

  environment.systemPackages = [pkgs.rclone];

  fileSystems = {
    "${mediaDirectory}" = {
      device = "/dev/sdb";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime"];
    };

    "${mediaDirectory}/Anime" = {
      device = "b2:aly-anime";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "buffer-size=256M"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=168h" # Cache files for up to 7 days (168 hours)
        "vfs-cache-max-size=30G" # Cache up to 30GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=3G" # Preload 3GB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };

    "${mediaDirectory}/Audiobooks" = {
      device = "b2:aly-audiobooks";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "buffer-size=256M"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=168h" # Cache files for up to 7 days (168 hours)
        "vfs-cache-max-size=1G" # Cache up to 1GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=3G" # Preload 3GB of data for smoother playback
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
        "buffer-size=256M"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=168h" # Cache files for up to 7 days (168 hours)
        "vfs-cache-max-size=40G" # Cache up to 40GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=3G" # Preload 3GB of data for smoother playback
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
        "buffer-size=256M"
        "cache-dir=${mediaDirectory}/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=168h" # Cache files for up to 7 days (168 hours)
        "vfs-cache-max-size=60G" # Cache up to 60GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=3G" # Preload 3GB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [2049]; # NFS
      allowedUDPPorts = [2049];
    };

    hostName = "mauville";
  };

  services = {
    nfs.server = {
      enable = true;

      exports = ''
        /mnt/Media 100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash,fsid=0)
      '';
    };

    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          security = "user";
          "map to guest" = "Bad User";

          # Protocol tuning
          "server min protocol" = "SMB3";
          "server max protocol" = "SMB3_11";

          # Performance options
          "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=262144 SO_SNDBUF=262144";
          "use sendfile" = "no"; # Plex compatibility
          "aio read size" = "1";
          "aio write size" = "1";
          "min receivefile size" = "131072"; # Bump slightly from 16K to 128K
          "max xmit" = "65535"; # Samba's max recommended for best throughput

          # Locking & latency
          "strict locking" = "no";
          "oplocks" = "yes";
          "level2 oplocks" = "yes";
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
      swap.enable = true;
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
        syncMusic = false;
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
