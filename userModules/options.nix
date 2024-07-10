{
  config,
  lib,
  pkgs,
  ...
}: {
  options.ar.users = let
    mkUser = user: {
      enable = lib.mkEnableOption "${user}.";

      password = lib.mkOption {
        description = "Hashed password for ${user}.";
        type = lib.types.str;
      };
    };
  in {
    defaultGroups = lib.mkOption {
      description = "Default groups for desktop users.";
      default = [
        "dialout"
        "docker"
        "libvirtd"
        "lp"
        "networkmanager"
        "scanner"
        "transmission"
        "video"
        "wheel"
      ];
    };

    aly =
      mkUser "aly"
      // {
        syncthing = {
          enable = lib.mkEnableOption "Syncthing sync service.";

          certFile = lib.mkOption {
            description = "Syncthing cert file.";
            type = lib.types.nonEmptyStr;
          };

          keyFile = lib.mkOption {
            description = "Syncthing key file.";
            type = lib.types.nonEmptyStr;
          };

          musicPath = lib.mkOption {
            description = "Whether to sync music folder.";
            default = "/home/aly/music";
            type = lib.types.str;
          };

          syncMusic = lib.mkOption {
            description = "Whether to sync music folder.";
            default = config.ar.users.aly.syncthing.enable;
            type = lib.types.bool;
          };
        };
      };

    dustin = mkUser "dustin";
  };
}
