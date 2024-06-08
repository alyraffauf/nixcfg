{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./audiobookshelf
    ./navidrome
  ];
}
