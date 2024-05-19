{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      imports = [../../homeManagerModules];
      xdg.userDirs.music = "/mnt/Media/Music";
      alyraffauf.desktop.hyprland.autoSuspend = false;
      alyraffauf.desktop.sway.autoSuspend = false;
    }
  ];
  home-manager.users.aly = {
    imports = [../../aly.nix];
  };
  home-manager.users.dustin = {
    imports = [../../dustin.nix];
  };
}
