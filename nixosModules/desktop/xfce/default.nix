{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.xfce.enable =
      lib.mkEnableOption "XFCE desktop session.";
  };

  config = lib.mkIf config.alyraffauf.desktop.xfce.enable {
    # Enable Budgie.
    services = {
      xserver = {
        enable = true;
        desktopManager.xfce = {
          enable = true;
        };
      };
    };
  };
}
