{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.services.syncthing.syncMusic {
    services.syncthing = {
      settings = {
        folders = {
          "music" = {
            id = "6nzmu-z9der";
            path = config.ar.services.syncthing.musicPath;
            devices = ["lavaridge" "mauville" "petalburg" "rustboro" "wallace"];
          };
        };
      };
    };
  };
}
