{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../homeManagerModules ../../aly.nix];
    xdg.userDirs.music = "/mnt/Media/Music";
    alyraffauf.desktop.hyprland.autoSuspend = false;
    alyraffauf.desktop.sway.autoSuspend = false;
  };
}
