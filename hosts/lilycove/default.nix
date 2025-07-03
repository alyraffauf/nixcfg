{
  config,
  pkgs,
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
    ./prometheus.nix
    ./secrets.nix
    ./services.nix
    ./stylix.nix
    self.diskoConfigurations.luks-btrfs-subvolumes
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

  nixpkgs.overlays = [
    (_self: super: {
      headphones = super.headphones.overrideAttrs (old: let
        version = "0.6.4";
      in {
        inherit version;
        src = old.src.override {
          # keep fetchFromGitHub, just bump rev & hash
          rev = "v${version}";
          sha256 = "0gv7rasjbm4rf9izghibgf5fbjykvzv0ibqc2in1naagjivqrpq4";
        };
      });
    })
  ];

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/disk/by-id/nvme-PNY_CS2130_1TB_SSD_PNY211821050701050CC";

  myHardware = {
    amd = {
      cpu.enable = true;
      gpu.enable = true;
    };

    profiles.base.enable = true;
  };

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;

      arr = {
        enable = true;
        dataDir = "/mnt/Data";
      };

      backups.enable = true;
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
      caddy.enable = true;

      forgejo-runner = {
        enable = true;
        dockerContainers = 3;
        nativeRunners = 2;
      };

      plex = {
        enable = true;
        dataDir = "/mnt/Data";
        tautulli.enable = true;
      };

      prometheusNode.enable = true;
      promtail.enable = true;

      qbittorrent = {
        enable = true;

        package = pkgs.qbittorrent-nox.overrideAttrs (_old: rec {
          version = "5.1.0";
          src = pkgs.fetchFromGitHub {
            owner = "qbittorrent";
            repo = "qBittorrent";
            rev = "release-${version}";
            hash = "sha256-ZLmKEdvtOxCzEOnJ4JPQQhR427YA288vTRxpk6O0tUc=";
          };
        });

        port = config.mySnippets.tailnet.networkMap.qbittorrent.port;
      };

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

  myUsers.aly.enable = true;
}
