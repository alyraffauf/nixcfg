{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.budgie.enable =
      lib.mkEnableOption "Budgie desktop session.";
  };

  config = lib.mkIf config.alyraffauf.desktop.budgie.enable {
    # Enable Budgie.
    services = {
      xserver = {
        enable = true;
        desktopManager.budgie = {
          enable = true;
        };
      };
    };
  };
}
