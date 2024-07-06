{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./audiobookshelf
    ./freshRSS
    ./plexMediaServer
    ./transmission
  ];
}
