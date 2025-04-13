{config, ...}: {
  services.restic.backups = {
    homebridge =
      config.mySnippets.resticDefaults
      // {
        paths = ["/var/lib/homebridge"];
        repository = "rclone:b2:aly-backups/${config.networking.hostName}/homebridge";
      };
  };
}
