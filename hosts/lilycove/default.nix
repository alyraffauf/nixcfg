{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  filesDirectory = "/mnt/Files";
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

  environment = {
    systemPackages = with pkgs; [heroic];
    variables.GDK_SCALE = "2.0";
  };

  networking.hostName = "lilycove";
  security.sudo.wheelNeedsPassword = lib.mkForce true;

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
          comment = "Files @ ${config.networking.hostName}";
          path = filesDirectory;
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
      SUBVOLUME = "/mnt/Files";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
    };

    xserver.xkb.options = "ctrl:nocaps";
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop.hyprland = {
      enable = true;
      monitors = ["desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,auto,1.875000"];
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      gaming.enable = true;
      media-share.enable = true;
      swap.enable = true;
      wifi.enable = true;
      workstation.enable = true;
    };

    programs = {
      firefox.enable = true;
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
      steam.enable = true;
    };

    services = {
      greetd = {
        enable = true;
        autoLogin = "aly";
      };

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        musicPath = "${filesDirectory}/Music";
        syncMusic = false;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers = {
    aly = {
      enable = true;
      password = "$y$j9T$SHPShqI2IpRE101Ey2ry/0$0mhW1f9LbVY02ifhJlP9XVImge9HOpf23s9i1JFLIt9";
    };

    dustin = {
      enable = false;
      password = "$y$j9T$3mMCBnUQ.xjuPIbSof7w0.$fPtRGblPRSwRLj7TFqk1nzuNQk2oVlgvb/bE47sghl.";
    };
  };
}
