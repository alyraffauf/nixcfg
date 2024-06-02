{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.services.syncthing.syncMusic {
    services.syncthing = {
      settings = {
        folders = {
          "music" = {
            id = "6nzmu-z9der";
            path = config.alyraffauf.services.syncthing.musicPath;
            devices = ["lavaridge" "mauville" "petalburg" "rustboro" "wattson"];
          };
        };
      };
    };
  };
}
