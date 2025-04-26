{
  config,
  self,
  ...
}: let
  dataDirectory = "/mnt/Data";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
    self.nixosModules.locale-en-us
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];

  networking.hostName = "lilycove";

  services = {
    nextjs-ollama-llm-ui.enable = true;

    ollama = {
      enable = true;
      acceleration = "rocm";

      loadModels = [
        "deepseek-r1:14b"
        "gemma2:9b"
        "llama3.1:8b"
      ];

      rocmOverrideGfx = "10.3.0"; # We play pretend because ollama/ROCM does not support the 6700 XT.
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

        Files = {
          "create mask" = "0755";
          "directory mask" = "0755";
          "force group" = "users";
          "force user" = "aly";
          "guest ok" = "yes";
          "read only" = "no";
          browseable = "yes";
          comment = "Data @ ${config.networking.hostName}";
          path = dataDirectory;
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    snapper.configs.archive = {
      ALLOW_GROUPS = ["users"];
      FSTYPE = "btrfs";
      SUBVOLUME = "/mnt/Data";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
    };

    xserver.xkb.options = "ctrl:nocaps";
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      media-share.enable = true;
      server.enable = true;
      swap.enable = true;
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
        musicPath = "${dataDirectory}/syncthing/Music";
        romsPath = "${dataDirectory}/syncthing/ROMs";
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
