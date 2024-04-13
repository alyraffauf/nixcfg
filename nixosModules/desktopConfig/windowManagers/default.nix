{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./hyprland];

  security.pam.services.swaylock = {};
}
