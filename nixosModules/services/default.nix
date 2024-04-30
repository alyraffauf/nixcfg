{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./binaryCache ./flatpak ./ollama ./syncthing ./tailscale];
}
