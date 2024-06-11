{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.services.mpd.enable {
    services.mpd = {
      enable = true;
      musicDirectory = config.alyraffauf.services.mpd.musicDirectory;
    };
    services.mpd-mpris = {
      enable = true;
      mpd.port = config.services.mpd.network.port;
    };
  };
}
