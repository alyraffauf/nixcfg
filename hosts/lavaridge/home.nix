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
          services.easyeffects = {
            enable = true;
            preset = "framework13";
          };
        };
      }
    ];
  };
}
