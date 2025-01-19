{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.myHome.services.mpd.enable {
    services.mpd = {
      enable = true;
      musicDirectory = config.myHome.services.mpd.musicDirectory;
    };
    services.mpd-mpris = {
      enable = true;
      mpd.port = config.services.mpd.network.port;
    };
  };
}
