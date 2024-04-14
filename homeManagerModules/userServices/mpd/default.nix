{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    userServices.mpd.enable =
      lib.mkEnableOption "MPD user service.";
    userServices.mpd.musicDirectory = lib.mkOption {
      description = "Name of music directory";
      default = config.xdg.userDirs.music;
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.userServices.mpd.enable {
    services.mpd = {
      enable = true;
      musicDirectory = config.userServices.mpd.musicDirectory;
    };
    services.mpd-mpris = {
      enable = true;
      mpd.port = config.services.mpd.network.port;
    };
  };
}
