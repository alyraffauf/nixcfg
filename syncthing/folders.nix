{
  "sync" = {
    id = "default";
    path = "/home/aly/sync";
    devices = ["fallarbor" "gsgmba" "iphone12" "lavaridge" "mauville" "norman" "pacifidlog" "petalburg" "rustboro" "slateport" "winona"];
    versioning = {
      type = "staggered";
      params = {
        cleanInterval = "3600";
        maxAge = "1";
      };
    };
  };

  "screenshots" = {
    devices = ["fallarbor" "lavaridge" "mauville" "norman" "petalburg" "rustboro" "slateport" "winona"];
    id = "screenshots";
    path = "/home/aly/pics/screenshots";
    versioning = {
      params.cleanoutDays = "5";
      type = "trashcan";
    };
  };

  "music" = {
    devices = ["lavaridge" "mauville" "rustboro"];
    id = "6nzmu-z9der";
  };

  "roms" = {
    devices = ["lavaridge" "mauville" "pacifidlog" "petalburg"];
    id = "emudeck";
    path = "/home/aly/roms";
  };
}
