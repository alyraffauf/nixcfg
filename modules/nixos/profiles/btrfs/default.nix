{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = lib.optionals (config.services.xserver.enable) [pkgs.snapper-gui];

    services = {
      btrfs.autoScrub.enable = true;

      snapper = {
        configs.home = {
          ALLOW_GROUPS = ["users"];
          FSTYPE = "btrfs";
          SUBVOLUME = "/home";
          TIMELINE_CLEANUP = true;
          TIMELINE_CREATE = true;
        };

        persistentTimer = true;
      };
    };
  };
}
