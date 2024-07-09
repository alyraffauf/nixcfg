{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        ar.home = {
          desktop = {
            hyprland.autoSuspend = false;
            sway.autoSuspend = false;
          };
        };
      }
    ];
  };
}
