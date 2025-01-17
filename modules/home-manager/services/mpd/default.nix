{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.services.mpd.enable {
    services.mpd = {
      enable = true;
      musicDirectory = config.ar.home.services.mpd.musicDirectory;
    };
    services.mpd-mpris = {
      enable = true;
      mpd.port = config.services.mpd.network.port;
    };
  };
}
