{config, ...}: let
  dataDirectory = "/mnt/Data";
in {
  networking.firewall.allowedTCPPorts = [6881];

  services = {
    caddy.virtualHosts = {
      "${config.mySnippets.tailnet.networkMap.bazarr.vHost}" = {
        extraConfig = ''
          bind tailscale/bazarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.bazarr.hostName}:${toString config.mySnippets.tailnet.networkMap.bazarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.jellyfin.vHost}" = {
        extraConfig = ''
          bind tailscale/jellyfin
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.jellyfin.hostName}:${toString config.mySnippets.tailnet.networkMap.jellyfin.port} {
            flush_interval -1
          }
        '';
      };

      "${config.mySnippets.tailnet.networkMap.lidarr.vHost}" = {
        extraConfig = ''
          bind tailscale/lidarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.lidarr.hostName}:${toString config.mySnippets.tailnet.networkMap.lidarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.ollama.vHost}" = {
        extraConfig = ''
          bind tailscale/ollama
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.ollama.hostName}:${toString config.mySnippets.tailnet.networkMap.ollama.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.prowlarr.vHost}" = {
        extraConfig = ''
          bind tailscale/prowlarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.prowlarr.hostName}:${toString config.mySnippets.tailnet.networkMap.prowlarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.qbittorrent.vHost}" = {
        extraConfig = ''
          bind tailscale/qbittorrent
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.qbittorrent.hostName}:${toString config.mySnippets.tailnet.networkMap.qbittorrent.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.radarr.vHost}" = {
        extraConfig = ''
          bind tailscale/radarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.radarr.hostName}:${toString config.mySnippets.tailnet.networkMap.radarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.sonarr.vHost}" = {
        extraConfig = ''
          bind tailscale/sonarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.sonarr.hostName}:${toString config.mySnippets.tailnet.networkMap.sonarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.tautulli.vHost}" = {
        extraConfig = ''
          bind tailscale/tautulli
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.tautulli.hostName}:${toString config.mySnippets.tailnet.networkMap.tautulli.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.vscode.vHost}" = {
        extraConfig = ''
          bind tailscale/vscode
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.vscode.hostName}:${toString config.mySnippets.tailnet.networkMap.vscode.port}
        '';
      };
    };

    headphones = {
      enable = true;
      host = "0.0.0.0";
      port = 8585;
    };

    immich = {
      enable = true;
      host = "0.0.0.0";
      mediaLocation = "${dataDirectory}/immich";
      openFirewall = true;
      inherit (config.mySnippets.cute-haus.networkMap.immich) port;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      dataDir = "${dataDirectory}/jellyfin";
    };

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
      host = "0.0.0.0";

      loadModels = [
        "gemma3:12b"
        "gemma3:4b"
        "nomic-embed-text"
      ];

      openFirewall = true;
      rocmOverrideGfx = "10.3.0"; # We play pretend because ollama/ROCM does not support the 6700.
    };

    ombi = {
      inherit (config.mySnippets.cute-haus.networkMap.ombi) port;
      enable = true;
      dataDir = "/mnt/Data/ombi";
      openFirewall = true;
    };

    openvscode-server = {
      inherit (config.mySnippets.tailnet.networkMap.vscode) port;
      enable = true;
      host = "0.0.0.0";
      user = "aly";
      withoutConnectionToken = true;
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
