{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./forgejo
    ./navidrome
  ];
}
