# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  pkgs,
  self,
  ...
}: let
  archiveDirectory = "/mnt/Archive";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
    self.nixosModules.locale-en-us
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];

  environment = {
    systemPackages = with pkgs; [heroic];
    variables.GDK_SCALE = "1.0";
  };

  networking.hostName = "lilycove";

  services = {
    nextjs-ollama-llm-ui.enable = true;

    ollama = {
      enable = true;
      acceleration = "rocm";

      loadModels = [
        "deepseek-r1:14b"
        "deepseek-r1:8b"
        "gemmma2:9b"
        "llama3.1:8b"
        "llama3.2:3b"
      ];

      rocmOverrideGfx = "10.3.0"; # We play pretend because ollama/ROCM does not support the 6700 XT.
    };

    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          security = "user";
          "read raw" = "Yes";
          "write raw" = "Yes";
          "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
          "min receivefile size" = 16384;
          "use sendfile" = true;
          "aio read size" = 16384;
          "aio write size" = 16384;
        };

        Archive = {
          "create mask" = "0755";
          "directory mask" = "0755";
          "force group" = "users";
          "force user" = "aly";
          "guest ok" = "yes";
          "read only" = "no";
          browsable = "yes";
          comment = "Archive @ ${config.networking.hostName}";
          path = archiveDirectory;
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
      SUBVOLUME = "/mnt/Archive";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
    };

    xserver.xkb.options = "ctrl:nocaps";
  };

  system.stateVersion = "24.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop = {
      hyprland = {
        enable = false;
        monitors = ["desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.0,vrr,2"];
      };

      kde.enable = true;
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      desktop.enable = true;
      gaming.enable = true;
      media-share.enable = true;
      wifi.enable = true;
    };

    programs = {
      firefox.enable = true;
      nix.enable = true;
      steam.enable = true;
    };

    services = {
      sddm = {
        enable = true;
        autologin = "aly";
      };

      sunshine.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = true;
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
