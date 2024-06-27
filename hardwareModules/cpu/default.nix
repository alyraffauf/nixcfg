{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./amd
    ./intel
  ];
}
