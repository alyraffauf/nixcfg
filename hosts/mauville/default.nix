{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./backups.nix
    ./disko.nix
    ./grafana.nix
    ./home.nix
    ./secrets.nix
    ./services.nix
    self.nixosModules.locale-en-us
  ];

  environment.systemPackages = [pkgs.rclone];

  fileSystems = let
    b2Options = [
      "allow_other"
      "args2env"
      "cache-dir=/mnt/Storage/.rclone-cache"
      "config=${config.age.secrets.rclone-b2.path}"
      "dir-cache-time=1h"
      "nodev"
      "nofail"
      "vfs-cache-mode=full"
      "vfs-write-back=10s"
      "x-systemd.after=network-online.target"
      "x-systemd.automount"
    ];

    b2ProfileOptions = {
      audio = [
        "buffer-size=128M"
        "vfs-cache-max-age=168h"
        "vfs-cache-max-size=10G"
        "vfs-read-ahead=3G"
      ];

      video = [
        "buffer-size=512M"
        "vfs-cache-max-age=336h"
        "vfs-cache-max-size=200G"
        "vfs-read-ahead=5G"
      ];
    };

    mkB2Mount = name: remote: profile: {
      "/mnt/Backblaze/${name}" = {
        device = "b2:${remote}";
        fsType = "rclone";
        options = b2Options ++ b2ProfileOptions.${profile};
      };
    };
  in
    mkB2Mount "Anime" "aly-anime" "video"
    // mkB2Mount "Audiobooks" "aly-audiobooks" "audio"
    // mkB2Mount "Movies" "aly-movies" "video"
    // mkB2Mount "Shows" "aly-shows" "video"
    // {
      "/mnt/Storage" = {
        device = "/dev/disk/by-id/ata-CT2000BX500SSD1_2345E8842829";
        fsType = "btrfs";
        options = ["compress=zstd" "noatime" "nofail"];
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

  powerManagement.powertop.enable = true;

  services = {
    nfs.server = {
      enable = true;

      exports = ''
        /mnt/Storage 100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash,fsid=0)
      '';
    };
  };

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";
  myHardware.beelink.mini.s12pro.enable = true;

  myNixOS = {
    profiles = {
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };

      base.enable = true;
      btrfs.enable = true;
      data-share.enable = true;
      media-share.enable = true;
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
      caddy.enable = true;
      prometheusNode.enable = true;
      promtail.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        musicPath = "/mnt/Media/Music";
        syncMusic = false;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly.enable = true;
}
