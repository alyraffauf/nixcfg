# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  archiveDirectory = "/mnt/Archive";
  domain = "raffauflabs.com";
  mediaDirectory = "/mnt/Media";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.inputs.nixhw.nixosModules.common-amd-cpu
    self.inputs.nixhw.nixosModules.common-amd-gpu
    self.inputs.nixhw.nixosModules.common-bluetooth
    self.inputs.nixhw.nixosModules.common-ssd
    self.inputs.raffauflabs.nixosModules.raffauflabs
    self.nixosModules.common-auto-upgrade
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-nix
    self.nixosModules.common-overlays
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "r8169"];
      systemd.enable = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };
  };

  hardware.enableAllFirmware = true;
  networking.hostName = "mauville";

  services = {
    forgejo.settings.service.DISABLE_REGISTRATION = lib.mkForce true;

    samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";

      extraConfig = ''
        read raw = Yes
        write raw = Yes
        socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072
        min receivefile size = 16384
        use sendfile = true
        aio read size = 16384
        aio write size = 16384
      '';

      shares = {
        Media = {
          browseable = "yes";
          comment = "Media @ ${config.networking.hostName}";
          path = mediaDirectory;
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0755";
          "directory mask" = "0755";
        };

        Archive = {
          browseable = "yes";
          comment = "Archive @ ${config.networking.hostName}";
          path = archiveDirectory;
          "create mask" = "0755";
          "directory mask" = "0755";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      credentialsFile = config.age.secrets.transmission.path;
      openFirewall = true;
      openRPCPort = true;

      settings = {
        download-dir = mediaDirectory;
        peer-port = 51413;
        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;
      };
    };
  };

  environment.variables.GDK_SCALE = "1.25";
  system.stateVersion = "24.05";
  zramSwap.memoryPercent = 100;

  ar = {
    apps = {
      firefox.enable = true;
      nicotine-plus.enable = true;
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    desktop = {
      greetd = {
        enable = true;
        autologin = "aly";
        session = lib.getExe config.programs.sway.package;
      };

      steam.enable = true;
      sway.enable = true;
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
        };
      };

      dustin = {
        enable = true;
        password = "$y$j9T$3mMCBnUQ.xjuPIbSof7w0.$fPtRGblPRSwRLj7TFqk1nzuNQk2oVlgvb/bE47sghl.";
      };
    };
  };

  raffauflabs = {
    inherit domain;
    enable = true;

    containers.oci.freshRSS.enable = true;

    services = {
      audiobookshelf.enable = true;

      ddclient = {
        enable = true;
        passwordFile = config.age.secrets.cloudflare.path;
        protocol = "cloudflare";
      };

      forgejo.enable = true;

      navidrome = {
        enable = true;

        lastfm = {
          idFile = config.age.secrets.lastfmId.path;
          secretFile = config.age.secrets.lastfmSecret.path;
        };

        spotify = {
          idFile = config.age.secrets.spotifyId.path;
          secretFile = config.age.secrets.spotifySecret.path;
        };
      };

      plexMediaServer.enable = true;
    };
  };
}
