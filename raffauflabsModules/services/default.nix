{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./navidrome
    ./forgejo
  ];
}
