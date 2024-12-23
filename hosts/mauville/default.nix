# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  pkgs,
  self,
  ...
}: let
  archiveDirectory = "/mnt/Archive";
  mediaDirectory = "/mnt/Media";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.common-auto-upgrade
    self.nixosModules.common-base
    self.nixosModules.common-lanzaboote
    self.nixosModules.common-locale
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-common
    self.nixosModules.hw-common-amd-cpu
    self.nixosModules.hw-common-amd-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-ssd
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];
  networking.hostName = "mauville";

  services = {
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

        Archive = {
          "create mask" = "0755";
          "directory mask" = "0755";
          "force group" = "users";
          "force user" = "aly";
          "guest ok" = "yes";
          "read only" = "no";
          browseable = "yes";
          comment = "Archive @ ${config.networking.hostName}";
          path = archiveDirectory;
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [heroic];
    variables.GDK_SCALE = "1.25";
  };

  system.stateVersion = "24.05";

  ar = {
    apps = {
      firefox.enable = true;
      nicotine-plus.enable = true;
      podman.enable = true;
      steam.enable = true;
    };

    desktop = {
      desktopOptimizations.enable = true;
      kde.enable = true;

      sddm = {
        enable = true;
        autologin = "aly";
      };
    };

    users = {
      aly = {
        enable = true;
        password = "$y$j9T$SHPShqI2IpRE101Ey2ry/0$0mhW1f9LbVY02ifhJlP9XVImge9HOpf23s9i1JFLIt9";

        syncthing = {
          enable = true;
          certFile = config.age.secrets.syncthingCert.path;
          keyFile = config.age.secrets.syncthingKey.path;
          musicPath = "${mediaDirectory}/Music";
          syncMusic = true;
          syncROMs = true;
        };
      };

      dustin = {
        enable = false;
        password = "$y$j9T$3mMCBnUQ.xjuPIbSof7w0.$fPtRGblPRSwRLj7TFqk1nzuNQk2oVlgvb/bE47sghl.";
      };
    };
  };
}
