{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing file syncing service.";

    certFile = lib.mkOption {
      description = "Path to the certificate file.";
      type = lib.types.path;
    };

    keyFile = lib.mkOption {
      description = "Path to the key file.";
      type = lib.types.path;
    };

    musicPath = lib.mkOption {
      default = "/home/${config.myNixOS.services.syncthing.user}/music";
      description = "Path to the music folder.";
      type = lib.types.path;
    };

    romsPath = lib.mkOption {
      default = "/home/${config.myNixOS.services.syncthing.user}/roms";
      description = "Path to the ROM folder.";
      type = lib.types.path;
    };

    syncMusic = lib.mkEnableOption "Whether to sync music.";
    syncROMs = lib.mkEnableOption "Whether to sync ROMs.";

    user = lib.mkOption {
      description = "User to run Syncthing as.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.syncthing.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services = {
      caddy.virtualHosts =
        lib.mkIf
        (
          config.myNixOS.services.caddy.enable
          && config.myNixOS.services.tailscale.enable
        ) {
          "syncthing-${config.networking.hostName}.${config.mySnippets.tailnet}" = {
            extraConfig = ''
              bind tailscale/syncthing-${config.networking.hostName}
              reverse_proxy localhost:8384 {
                header_up Host localhost
              }
            '';
          };
        };

      syncthing = let
        cfg = config.myNixOS.services.syncthing;

        folders = lib.mkMerge [
          config.mySnippets.syncthing.folders
          {
            "music" = {
              enable = cfg.syncMusic;
              path = cfg.musicPath;
            };

            "roms" = {
              enable = cfg.syncROMs;
              path = cfg.romsPath;
            };
          }
        ];
      in {
        inherit (cfg) enable user;
        cert = cfg.certFile;
        configDir = "${config.services.syncthing.dataDir}/.syncthing";
        dataDir = "/home/${cfg.user}";
        key = cfg.keyFile;
        openDefaultPorts = true;

        settings = {
          options = {
            localAnnounceEnabled = true;
            relaysEnabled = true;
            urAccepted = -1;
          };

          inherit folders;
          inherit (config.mySnippets.syncthing) devices;
        };
      };
    };
  };
}
