{config, ...}: let
  dataDirectory = "/mnt/Data";
in {
  networking.firewall.allowedTCPPorts = [6881];

  services = {
    caddy.virtualHosts = {
      "bazarr.${config.mySnippets.tailnet}" = {
        extraConfig = ''
          bind tailscale/bazarr
          encode zstd gzip
          reverse_proxy localhost:${toString config.services.bazarr.listenPort}
        '';
      };

      "lidarr.${config.mySnippets.tailnet}" = {
        extraConfig = ''
          bind tailscale/lidarr
          encode zstd gzip
          reverse_proxy localhost:${toString config.services.lidarr.settings.server.port}
        '';
      };

      "prowlarr.${config.mySnippets.tailnet}" = {
        extraConfig = ''
          bind tailscale/prowlarr
          encode zstd gzip
          reverse_proxy localhost:${toString config.services.prowlarr.settings.server.port}
        '';
      };

      "radarr.${config.mySnippets.tailnet}" = {
        extraConfig = ''
          bind tailscale/radarr
          encode zstd gzip
          reverse_proxy localhost:${toString config.services.radarr.settings.server.port}
        '';
      };

      "readarr.${config.mySnippets.tailnet}" = {
        extraConfig = ''
          bind tailscale/readarr
          encode zstd gzip
          reverse_proxy localhost:${toString config.services.readarr.settings.server.port}
        '';
      };

      "sonarr.${config.mySnippets.tailnet}" = {
        extraConfig = ''
          bind tailscale/sonarr
          encode zstd gzip
          reverse_proxy localhost:${toString config.services.sonarr.settings.server.port}
        '';
      };
    };

    immich = {
      enable = true;
      host = "0.0.0.0";
      mediaLocation = "${dataDirectory}/immich";
      openFirewall = true;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      dataDir = "${dataDirectory}/jellyfin";
    };

    nextjs-ollama-llm-ui.enable = true;

    nfs.server = {
      enable = true;

      exports = ''
        /mnt/Data 100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash,fsid=0)
        /mnt/Media 100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash,fsid=1)
      '';
    };

    ollama = {
      enable = true;
      acceleration = "rocm";

      loadModels = [
        "deepseek-r1:14b"
        "gemma2:9b"
        "llama3.1:8b"
      ];

      rocmOverrideGfx = "10.3.0"; # We play pretend because ollama/ROCM does not support the 6700.
    };

    ombi = {
      enable = true;
      dataDir = "/mnt/Data/ombi";
      openFirewall = true;
    };

    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          security = "user";
          "map to guest" = "Bad User";

          # Protocol tuning
          "server min protocol" = "SMB3";
          "server max protocol" = "SMB3_11";

          # Performance options
          "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=262144 SO_SNDBUF=262144";
          "use sendfile" = "no"; # Plex compatibility
          "aio read size" = "1";
          "aio write size" = "1";
          "min receivefile size" = "131072"; # Bump slightly from 16K to 128K
          "max xmit" = "65535"; # Samba's max recommended for best throughput

          # Locking & latency
          "strict locking" = "no";
          "oplocks" = "yes";
          "level2 oplocks" = "yes";
        };

        Data = {
          "create mask" = "0755";
          "directory mask" = "0755";
          "force group" = "users";
          "force user" = "aly";
          "guest ok" = "yes";
          "read only" = "no";
          browseable = "yes";
          comment = "Data @ ${config.networking.hostName}";
          path = dataDirectory;
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
          path = "/mnt/Media";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    snapper.configs.media = {
      ALLOW_GROUPS = ["users"];
      FSTYPE = "btrfs";
      SUBVOLUME = "/mnt/Media";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
    };

    xserver.xkb.options = "ctrl:nocaps";
  };
}
