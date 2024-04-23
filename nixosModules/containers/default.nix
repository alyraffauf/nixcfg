{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./nixos ./oci];
}
