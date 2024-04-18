{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.mpd.enable =
      lib.mkEnableOption "MPD user service.";
    alyraffauf.services.mpd.musicDirectory = lib.mkOption {
      description = "Name of music directory";
      default = config.xdg.userDirs.music;
      type = lib.types.str;
    };
  };

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
