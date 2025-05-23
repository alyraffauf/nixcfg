{
  config,
  self,
  ...
}: let
  dataDirectory = "/mnt/Data";
in {
  imports = [
    ./backups.nix
    ./b2.nix
    ./home.nix
    ./oci.nix
    ./secrets.nix
    ./services.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
    self.nixosModules.locale-en-us
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];
    kernelModules = ["sg"];
  };

  fileSystems = {
    "/mnt/Data" = {
      device = "/dev/disk/by-id/ata-CT4000BX500SSD1_2447E9959972";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime" "nofail"];
    };

    "/mnt/Media" = {
      device = "/dev/disk/by-id/ata-ST14000NM001G-2KJ103_ZL201XNJ-part1";
      fsType = "btrfs";
      options = ["subvol=@media" "compress=zstd" "noatime" "nofail"];
    };
  };

  networking = {
    firewall.allowedTCPPorts = [5143 6881];
    hostName = "lilycove";
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myDisko.installDrive = "/dev/disk/by-id/nvme-PNY_CS2130_1TB_SSD_PNY211821050701050CC";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;

      arr = {
        enable = true;
        backup = true;
        dataDir = "/mnt/Data";
      };

      base.enable = true;
      btrfs.enable = true;
      server.enable = true;
      swap.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      forgejo-runner = {
        enable = true;
        number = 4;
      };

      qbittorrent.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        musicPath = "${dataDirectory}/syncthing/Music";
        romsPath = "${dataDirectory}/syncthing/ROMs";
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
