{config, ...}: let
  dataDirectory = "/mnt/Data";
in {
  services = {
    nextjs-ollama-llm-ui.enable = true;

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
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    snapper.configs.archive = {
      ALLOW_GROUPS = ["users"];
      FSTYPE = "btrfs";
      SUBVOLUME = "/mnt/Data";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
    };

    xserver.xkb.options = "ctrl:nocaps";
  };
}
