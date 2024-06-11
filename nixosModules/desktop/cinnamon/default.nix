{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.cinnamon.enable {
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
