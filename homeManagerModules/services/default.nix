{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./syncthing ./easyeffects ./mpd];

  alyraffauf.services.syncthing.enable = lib.mkDefault true;
}
