{
  "obsidian" = {
    devices = ["dewford" "fallarbor" "groudon" "gsgmba" "iphone12" "lilycove" "mauville" "norman" "pacifidlog" "petalburg" "rustboro" "slateport" "sootopolis" "winona"];
    id = "obsidian";
    path = "/home/aly/obsidian";

    versioning = {
      type = "staggered";
      params = {
        cleanInterval = "3600";
        maxAge = "1";
      };
    };
  };

  "sync" = {
    devices = ["dewford" "fallarbor" "groudon" "gsgmba" "iphone12" "lilycove" "mauville" "norman" "pacifidlog" "petalburg" "rustboro" "slateport" "sootopolis" "winona"];
    id = "default";
    path = "/home/aly/sync";

    versioning = {
      type = "staggered";
      params = {
        cleanInterval = "3600";
        maxAge = "1";
      };
    };
  };

  "screenshots" = {
    devices = ["fallarbor" "lilycove" "mauville" "norman" "petalburg" "rustboro" "slateport" "sootopolis" "winona"];
    id = "screenshots";
    path = "/home/aly/pics/screenshots";

    versioning = {
      params.cleanoutDays = "5";
      type = "trashcan";
    };
  };

  "music" = {
    devices = ["lilycove" "mauville" "petalburg" "rustboro" "sootopolis"];
    id = "6nzmu-z9der";
  };

  "roms" = {
    devices = ["dewford" "lilycove" "mauville" "pacifidlog" "petalburg" "sootopolis"];
    id = "emudeck";
    path = "/home/aly/roms";
  };
}
