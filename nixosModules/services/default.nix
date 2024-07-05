{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./flatpak
    ./navidrome
    ./syncthing
    ./tailscale
  ];
}
