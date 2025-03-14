{
  "sync" = {
    devices = [
      "dewford"
      "fallarbor"
      "groudon"
      "gsgmba"
      "kyogre"
      "lilycove"
      "mauville"
      "norman"
      "pacifidlog"
      "rustboro"
      "slateport"
      "sootopolis"
    ];

    id = "default";
    path = "/home/aly/sync";

    versioning = {
      params = {
        cleanInterval = "3600";
        maxAge = "1";
      };

      type = "staggered";
    };
  };

  "screenshots" = {
    devices = [
      "fallarbor"
      "lilycove"
      "mauville"
      "norman"
      "rustboro"
      "slateport"
      "sootopolis"
    ];

    id = "screenshots";
    path = "/home/aly/pics/screenshots";

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
      "lilycove"
      "mauville"
      "pacifidlog"
      "sootopolis"
    ];

    id = "emudeck";
    path = "/home/aly/roms";
  };
}
