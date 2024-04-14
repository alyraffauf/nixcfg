{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./syncthing ./easyeffects ./mpd];

  userServices.syncthing.enable = lib.mkDefault true;
}
