# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  input,
  lib,
  pkgs,
  self,
  ...
}: let
  acmeEmail = "alyraffauf@gmail.com";
  hostName = "mauville";
  domain = "raffauflabs.com";
  mediaDirectory = "/mnt/Media";
  archiveDirectory = "/mnt/Archive";
in {
  imports = [
    ./hardware.nix
    ./home.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostName; # Define your hostname.

  alyraffauf = {
    apps = {
      nicotine-plus.enable = true;
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };
    containers = {
      nixos = {
        navidrome.enable = true;
      };
      oci = {
        audiobookshelf.enable = true;
        freshRSS.enable = true;
        plexMediaServer.enable = true;
        transmission.enable = true;
      };
    };
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = lib.getExe config.programs.hyprland.package;
        autologin = {
          enable = true;
          user = "aly";
        };
      };
      hyprland.enable = true;
      sway.enable = true;
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
      binaryCache.enable = true;
      ollama = {
        enable = true;
        gpu = "amd";
        listenAddress = "0.0.0.0:11434";
      };
      syncthing = {
        enable = true;
        syncMusic = true;
        musicPath = "${mediaDirectory}/Music";
      };
      tailscale.enable = true;
    };
    scripts = {
      hoenn.enable = true;
    };
    base = {
      enable = true;
      plymouth.enable = true;
      zramSwap = {
        enable = true;
        size = 100;
      };
    };
  };

  networking = {
    firewall = let
      transmissionPort = config.alyraffauf.containers.oci.transmission.port;
      bitTorrentPort = config.alyraffauf.containers.oci.transmission.bitTorrentPort;
    in {
      allowedTCPPorts = [80 443 transmissionPort bitTorrentPort];
      allowedUDPPorts = [bitTorrentPort];
    };
    # My router doesn't expose settings for NAT loopback
    # So we have to use this workaround.
    extraHosts = ''
      127.0.0.1 music.${domain}
      127.0.0.1 news.${domain}
      127.0.0.1 nixcache.${domain}
      127.0.0.1 plex.${domain}
      127.0.0.1 podcasts.${domain}
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmail;
  };

  services = {
    fail2ban.enable = true;
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "music.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:4533";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "news.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.alyraffauf.containers.oci.freshRSS.port}";
            proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig = ''
              proxy_buffering off;
              proxy_redirect off;
              # Forward the Authorization header for the Google Reader API.
              proxy_pass_header Authorization;
              proxy_set_header Authorization $http_authorization;
            '';
          };
        };

        "nixcache.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${
            toString config.services.nix-serve.port
          }";
        };

        "plex.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.alyraffauf.containers.oci.plexMediaServer.port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };

        "podcasts.${domain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.alyraffauf.containers.oci.audiobookshelf.port}";
            # proxyWebsockets = true; # This breaks audiobookshelf.
            extraConfig = ''
              client_max_body_size 500M;
              proxy_buffering off;
              proxy_redirect                      http:// https://;
              proxy_set_header Host               $host;
              proxy_set_header X-Forwarded-Proto  $scheme;
              proxy_set_header Connection         "upgrade";
              proxy_set_header Upgrade            $http_upgrade;
              proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
            '';
          };
        };
      };
    };
    samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      shares = {
        Media = {
          browseable = "yes";
          comment = "Media @ ${hostName}";
          path = mediaDirectory;
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0755";
          "directory mask" = "0755";
        };
        Archive = {
          browseable = "yes";
          comment = "Archive @ ${hostName}";
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
  };

  system.stateVersion = "23.11";
}
