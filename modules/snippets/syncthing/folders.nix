{lib, ...}: {
  options = {
    mySnippets.syncthing.folders = lib.mkOption {
      description = "List of Syncthing folders.";
      type = lib.types.attrs;

      default = {
        "sync" = {
          devices = [
            "dewford"
            "fallarbor"
            "fortree"
            "groudon"
            "kyogre"
            "lavaridge"
            "lilycove"
            "mauville"
            "pacifidlog"
            "rustboro"
            "slateport"
            "sootopolis"
          ];

          id = "default";
          path = "~/sync";

          versioning = {
            params.cleanoutDays = "5";
            type = "trashcan";
          };
        };

        "screenshots" = {
          devices = [
            "fallarbor"
            "lavaridge"
            "lilycove"
            "mauville"
            "rustboro"
            "slateport"
            "sootopolis"
          ];

          id = "screenshots";
          path = "~/pics/screenshots";

          versioning = {
            params.cleanoutDays = "5";
            type = "trashcan";
          };
        };

        "music" = {
          devices = [
            "lilycove"
            "mauville"
            "rustboro"
            "sootopolis"
          ];

          id = "6nzmu-z9der";
        };

        "roms" = {
          devices = [
            "dewford"
            "lavaridge"
            "lilycove"
            "mauville"
            "pacifidlog"
            "sootopolis"
          ];

          id = "emudeck";
        };
      };
    };
  };
}
