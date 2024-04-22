{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./nicotine-plus ./steam ./podman ./virt-manager];
}
