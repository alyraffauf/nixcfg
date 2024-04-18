{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./flatpak ./nicotine-plus ./steam ./podman ./virt-manager];
}
