{config, ...}: {
  services.restic.backups = {
    homebridge =
      config.mySnippets.restic
      // {
        paths = ["/var/lib/homebridge"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/homebridge";
      };
  };
}
