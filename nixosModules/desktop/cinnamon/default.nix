{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.cinnamon.enable =
      lib.mkEnableOption "Cinnamon desktop session.";
  };

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
