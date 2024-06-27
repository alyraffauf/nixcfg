{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.desktop.cinnamon.enable {
    services = {
      xserver = {
        enable = true;
        desktopManager.cinnamon = {
          enable = true;
        };
      };
    };
  };
}
