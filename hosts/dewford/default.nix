{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./proxy.nix
    ./secrets.nix
    ./stylix.nix
    self.diskoConfigurations.lvm-ext4
    self.nixosModules.locale-en-us
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
      ];

      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    htop
    rclone
    zellij
  ];

  fileSystems = let
    b2Options = [
      "allow_other"
      "args2env"
      "cache-dir=/mnt/Backblaze/.rclone-cache"
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
        "vfs-cache-max-size=15G"
        "vfs-read-ahead=1G"
      ];

      video = [
        "buffer-size=512M"
        "vfs-cache-max-age=336h"
        "vfs-cache-max-size=50G"
        "vfs-read-ahead=3G"
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
    // mkB2Mount "Music" "aly-music" "audio"
    // mkB2Mount "Shows" "aly-shows" "video";

  networking.hostName = "dewford";
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;
  system.stateVersion = "25.11";

  services = {
    couchdb = {
      inherit (config.mySnippets.tailnet.networkMap.couchdb) port;
      enable = true;
      bindAddress = "0.0.0.0";

      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = 50000000;
        };

        chttpd = {
          require_valid_user = true;
          max_http_request_size = 4294967296;
          enable_cors = true;
        };

        chttpd_auth = {
          require_valid_user = true;
          authentication_redirect = "/_utils/session.html";
        };

        httpd = {
          enable_cors = true;
          "WWW-Authenticate" = "Basic realm=\"couchdb\"";
          bind_address = "0.0.0.0";
        };

        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = true;
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET,PUT,POST,HEAD,DELETE";
          max_age = 3600;
        };
      };
    };

    qemuGuest.enable = true;

    uptime-kuma = {
      enable = true;
      appriseSupport = true;

      settings = {
        PORT = toString config.mySnippets.cute-haus.networkMap.uptime-kuma.port;
        HOST = "0.0.0.0";
      };
    };

    vaultwarden = {
      enable = true;

      config = {
        DOMAIN = "https://${config.mySnippets.cute-haus.networkMap.vaultwarden.vHost}";
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_LOG = "critical";
        ROCKET_PORT = config.mySnippets.cute-haus.networkMap.vaultwarden.port;
        SIGNUPS_ALLOWED = false;
      };

      environmentFile = config.age.secrets.vaultwarden.path;
    };
  };

  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/vda";

  myNixOS = {
    profiles = {
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };

      backups.enable = true;
      base.enable = true;
      data-share.enable = true;
      server.enable = true;
      swap.enable = true;
      media-share.enable = true;
    };

    programs.nix.enable = true;

    services = {
      caddy.enable = true;
      plex.enable = true;
      prometheusNode.enable = true;
      promtail.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.root.enable = true;
}
