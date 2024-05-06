{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./defaultApps.nix ./theme.nix ./gnome ./hypr ./sway ./river];
}
