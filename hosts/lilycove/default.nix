{
  config,
  self,
  ...
}: let
  dataDirectory = "/mnt/Data";
in {
  imports = [
    ./arr.nix
    ./b2.nix
    ./home.nix
    ./secrets.nix
    ./services.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
    self.nixosModules.locale-en-us
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];

  fileSystems = {
    "/mnt/Data" = {
      device = "/dev/disk/by-id/ata-CT2000BX500SSD1_2345E8842829";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime" "nofail"];
    };
  };

  networking.hostName = "lilycove";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  environment = {
    variables.GDK_SCALE = "2.0";
  };

  myNixOS = {
    desktop.hyprland = {
      enable = true;
      monitors = ["desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,auto,1.875000"];
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      media-share.enable = true;
      workstation.enable = true;
      swap.enable = true;
    };

    programs = {
      firefox.enable = true;
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
