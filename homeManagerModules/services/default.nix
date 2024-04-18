{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./syncthing ./easyeffects ./mpd];
}
