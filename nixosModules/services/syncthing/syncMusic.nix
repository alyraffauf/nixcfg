{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.syncthing.syncMusic = lib.mkOption {
      description = "Whether to sync music folder.";
      default = true;
      type = lib.types.bool;
    };
    alyraffauf.services.syncthing.syncMusicPath = lib.mkOption {
      description = "Whether to sync music folder.";
      default = "/home/${config.alyraffauf.services.syncthing.user}/music";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.services.syncthing.syncMusic {
    services.syncthing = {
      settings = {
        folders = {
          "music" = {
            id = "6nzmu-z9der";
            path = config.alyraffauf.services.syncthing.syncMusicPath;
            devices = ["lavaridge" "mauville" "petalburg" "rustboro" "wattson"];
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "1";
            };
          };
        };
      };
    };
  };
}
