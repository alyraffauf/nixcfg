{...}: {
  services = {
    btrfs.autoScrub.enable = true;

    snapper = {
      configs.home = {
        FSTYPE = "btrfs";
        SUBVOLUME = "/home";
        TIMELINE_CLEANUP = true;
        TIMELINE_CREATE = true;
      };

      persistentTimer = true;
    };
  };
}
