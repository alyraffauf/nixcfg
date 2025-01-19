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
    self.nixosModules.common-mauville-share
    self.nixosModules.hw-amd-cpu
    self.nixosModules.hw-amd-gpu
    self.nixosModules.hw-common
    self.nixosModules.locale-en-us
    self.nixosModules.nixos-desktop-kde
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-desktopOptimizations
    self.nixosModules.nixos-profiles-gaming
    self.nixosModules.nixos-profiles-wifi
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-lanzaboote
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-programs-podman
    self.nixosModules.nixos-programs-steam
    self.nixosModules.nixos-services-sddm
    self.nixosModules.nixos-services-sunshine
    self.nixosModules.nixos-services-syncthing
    self.nixosModules.nixos-services-tailscale
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];

  environment = {
    systemPackages = with pkgs; [heroic];
    variables.GDK_SCALE = "1.0";
  };

  networking.hostName = "lilycove";
  sddm.autologin = "aly";

  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
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

    snapper.configs.archive = {
      ALLOW_GROUPS = ["users"];
      FSTYPE = "btrfs";
      SUBVOLUME = "/mnt/Archive";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
    };
  };

  system.stateVersion = "24.05";

  myNixOS.syncthing = {
    enable = true;
    certFile = config.age.secrets.syncthingCert.path;
    keyFile = config.age.secrets.syncthingKey.path;
    syncMusic = true;
    syncROMs = true;
    user = "aly";
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
