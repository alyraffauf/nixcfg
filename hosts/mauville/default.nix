# Beelink S12 Pro mini PC with Intel N100, 16GB RAM, 500GB SSD + 2TB SSD.
{
  config,
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
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-common
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-ssd
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-lanzaboote
    self.nixosModules.nixos-programs-podman
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod" "r8169"];
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
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  system.stateVersion = "25.05";

  ar.users.aly = {
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
}
