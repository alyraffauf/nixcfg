{
  "sync" = {
    id = "default";
    path = "/home/aly/sync";
    devices = ["dewford" "fallarbor" "gsgmba" "iphone12" "lavaridge" "lilycove" "mauville" "norman" "pacifidlog" "petalburg" "rustboro" "slateport" "sootopolis" "winona"];

    versioning = {
      type = "staggered";
      params = {
        cleanInterval = "3600";
        maxAge = "1";
      };
    };
  };

  "screenshots" = {
    devices = ["fallarbor" "lavaridge" "lilycove" "mauville" "norman" "petalburg" "rustboro" "slateport" "sootopolis" "winona"];
    id = "screenshots";
    path = "/home/aly/pics/screenshots";

    versioning = {
      params.cleanoutDays = "5";
      type = "trashcan";
    };
  };

  "music" = {
    devices = ["lavaridge" "lilycove" "mauville" "petalburg" "rustboro" "sootopolis"];
    id = "6nzmu-z9der";
  };

  "roms" = {
    devices = ["dewford" "lavaridge" "lilycove" "mauville" "pacifidlog" "petalburg"];
    id = "emudeck";
    path = "/home/aly/roms";
  };
}
