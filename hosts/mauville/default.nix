# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  input,
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
    ./filesystems.nix
    ./hardware.nix
    ./home.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  system.stateVersion = "23.11";

  networking = {
    # My router doesn't expose settings for NAT loopback
    # So we have to use this workaround.
    extraHosts = ''
      127.0.0.1 git.${domain}
      127.0.0.1 music.${domain}
      127.0.0.1 news.${domain}
      127.0.0.1 nixcache.${domain}
      127.0.0.1 plex.${domain}
      127.0.0.1 podcasts.${domain}
    '';

    hostName = "mauville";
  };

  raffauflabs = {
    containers = {
      oci = {
        audiobookshelf.enable = true;
        freshRSS.enable = true;
        plexMediaServer.enable = true;
        transmission.enable = true;
      };
    };

    services.navidrome.enable = true;
  };

  ar = {
    apps = {
      firefox.enable = true;
      nicotine-plus.enable = true;
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    base = {
      enable = true;
      zramSwap.size = 100;
    };

    desktop = {
      greetd = {
        enable = true;

        autologin = {
          enable = true;
          user = "aly";
        };
      };

      hyprland.enable = true;
      steam.enable = true;
    };

    users = {
      aly = {
        enable = true;
        password = "$y$j9T$SHPShqI2IpRE101Ey2ry/0$0mhW1f9LbVY02ifhJlP9XVImge9HOpf23s9i1JFLIt9";
      };

      dustin = {
        enable = true;
        password = "$y$j9T$3mMCBnUQ.xjuPIbSof7w0.$fPtRGblPRSwRLj7TFqk1nzuNQk2oVlgvb/bE47sghl.";
      };
    };

    services = {
      syncthing = {
        enable = true;
        syncMusic = true;
        musicPath = "${mediaDirectory}/Music";
      };

      tailscale.enable = true;
    };
  };
}
