{
  "sync" = {
    devices = [
      "dewford"
      "fallarbor"
      "fortree"
      "groudon"
      "kyogre"
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
      "lilycove"
      "mauville"
      "pacifidlog"
      "sootopolis"
    ];

    id = "emudeck";
    path = "~/roms";
  };
}
