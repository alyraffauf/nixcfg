{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./theme.nix ./gnome ./hypr ./sway ./river];
}
