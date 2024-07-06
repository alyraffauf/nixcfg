{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./flatpak
    ./syncthing
    ./tailscale
  ];
}
