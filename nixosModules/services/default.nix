{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./flatpak
    ./ollama
    ./syncthing
    ./tailscale
  ];
}
