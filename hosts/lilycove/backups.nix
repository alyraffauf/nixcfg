{config, ...}: {
  services.restic.backups = {
    dizquetv =
      config.mySnippets.restic
      // {
        paths = ["/mnt/Data/dizquetv"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/dizquetv";
      };

    # syncthing-sync =
    #   config.mySnippets.restic
    #   // {
    #     paths = ["/home/aly/sync"];
    #     repository = "rclone:b2:aly-backups/syncthing/sync";
    #   };
  };
}
