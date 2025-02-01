{
  config,
  lib,
  ...
}: {
  options.myNixOS.syncthing = {
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
      default = "/home/${config.myNixOS.syncthing.user}/music";
      description = "Path to the music folder.";
      type = lib.types.path;
    };

    syncMusic = lib.mkEnableOption "Whether to sync music.";
    syncROMs = lib.mkEnableOption "Whether to sync ROMs.";

    user = lib.mkOption {
      description = "User to run Syncthing as.";
      type = lib.types.str;
    };
  };

  config = {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services.syncthing = let
      cfg = config.myNixOS.syncthing;
      devices = import ./devices.nix;

      folders = lib.mkMerge [
        (import ./folders.nix)
        {
          "music" = {
            enable = cfg.syncMusic;
            path = cfg.musicPath;
          };

          "roms".enable = cfg.syncROMs;
        }
      ];
    in {
      enable = true;
      cert = cfg.certFile;
      configDir = "${config.services.syncthing.dataDir}/.syncthing";
      dataDir = "/home/${cfg.user}";
      key = cfg.keyFile;
      openDefaultPorts = true;
      user = cfg.user;

      settings = {
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1;
        };

        inherit devices folders;
      };
    };
  };
}
