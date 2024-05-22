{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        imports = [../../homeManagerModules];
        xdg.userDirs.music = "/mnt/Media/Music";
        alyraffauf.desktop.hyprland.autoSuspend = false;
        alyraffauf.desktop.sway.autoSuspend = false;
      }
    ];
    users.aly = import ../../aly.nix;
    users.dustin = import ../../dustin.nix;
  };
}
