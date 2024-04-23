{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./audiobookshelf
    ./freshRSS
    ./jellyfin
    ./plexMediaServer
    ./transmission
  ];
}
