{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./gnome ./hypr ./sway ./river];
}
